## Logický projekt pre predmet FLP@FIT VUT, 2024
##      Hamiltonovská kružnica
## Autor: Sabína Gulčíková, xgulci00

### Popis riešenia
Program očakáva správne formátovaný vstup. Po jeho načítaní si jednotlivé uzly a hrany načíta do dynamických predikátov `vertex/1` a `edge/2`. V predikáte `hamiltonian_cycles` si následne vygeneruje zo všetkých uzlov všetky permutácie ich usporiadana. Každé takéto usporiadanie reprezentuje možnú cestu grafom.
Program následovne kontroluje platnosť jednotlivých permutácií, a to tak,   že kontroluje či je medzi susednými uzlami na potenciálnej ceste definovaná hrana, teda či platí `are_neighboring`. Zároveň kontroluje, či sa každý uzol na ceste nachádza práve raz pomocou `all_distinct`. Cesta, ktorá obsahuje duplicitné uzly by však nemala byť výsledkom permutácií.
Keďže Hamiltonovská kružnica je kružnicou, a každým uzlom prechádza len raz, nie je nutné ponechávať cesty začínajúce zo všetkých uzlov. Pre prvé odfiltrovanie duplicít sa teda vyberie počiatočný uzol, a všetky cesty, ktoré týmto uzlom nezačínajú sú vylúčené. Na prvy zoznamu `FilteredCycles` následne aplikujeme transformáciu, ktorá počiatočný uzol duplikuje a konkatenuje aj na jeho koniec, aby cesta tvorila skutočný cyklus. Cesty, či zoznamy uzlov vo formáte `[A,B,C,D,A]` sú nasledovne transformované do zoznamov hrán vo formáte `[[A,B],[B,C],[C,D],[A,D]]`, pričom konkatenácia susedných uzlov do hrán tieto uzly v dvojiciach rovno zoraďuje. Každá cesta je nasledovne zoradená naprieš hranami, a z takto zoradených ciest sú nakoniec odstránené duplicity. 
Po vyfiltrovaní unikátnych kružníc sú všetky formátované do vstupu definovaného zadaním, a výpisané na stdout.
Transformácie ciest uzlov a radenie boli implementované pre schopnosť odfiltrovania duplicít. Bez takýchto transformácií by nebolo možné zachovať informáciu o vzťahu medzi uzlami, a bez zoradenia by bolo nutné implementovať náročnejší mechanizmus porovnania identity dvoch ciest.

### Spustenie
Program je pre spustenie nutné preložiť priloženým Makefile súborom. Ten očakáva nasledujúcu štruktúru projektu.

**Očakávaná štruktúra projektu:**
```text
flp-log-xgulci00/
            |__src/
                |_ main.pl
                |_ input2.pl
            |__Makefile
            |__README.md
```

**Príkazy pre spustenie :**

`> make`

nasledovaný jedným z nasledujúcich príkazov: 
`> ./flp23-log < cesta_k_vstupu`,
`> echo "vstup" | ./flp23-log`, či
`> ./flp23-log < cesta_k_vstupu > cesta_k_vystupu` pre výpis výsledkov do žiadaneho súboru.

Napríklad:
`./flp23-log < data/in1.txt > data/out1.txt`

**príklad vstupu:**
```text
A B
A C
A D
B C
B D
C D
```

**príklad výstupu:**
```text
A-B A-C B-D C-D
A-B A-D B-C C-D
A-C A-D B-C B-D

```

### Známe obmedzenia
- súbor s výstupom vždy na konci obsahuje priazdny riadok,
- zoznam kružníc nie je zoradený naprieč riadkami.
