# asjer/versions

Homebrew-tap voor vastgezette versies van externe CLI-tools. Eigen project-CLI's horen in een aparte tap, `asjer/tap`.

## Beschikbare formules

| Formule | Versie | Platforms | Bron |
| --- | --- | --- | --- |
| `herdr@0.9.3` | 0.9.3 | macOS en Linux, ARM64 en x86_64 | [Officiële Herdr-release](https://github.com/herdrdev/herdr/releases/tag/v0.9.3) |

De formule gebruikt officiële releasebestanden met een SHA-256-checksum per platform en architectuur. Er wordt geen eigen Herdr-binary gebouwd. De licentie van Herdr is Apache-2.0.

## Installeren

```sh
brew tap asjer/versions
brew install asjer/versions/herdr@0.9.3
"$(brew --prefix asjer/versions/herdr@0.9.3)/bin/herdr" --version
```

Als Homebrew om vertrouwen vraagt, controleer dan deze repository voordat je de tap vertrouwt.

De formule is **keg-only**: installeren vervangt het bestaande `herdr`-commando niet. Gebruik het volledige pad hierboven om expliciet 0.9.3 te starten.

### Als standaardcommando gebruiken

Plan de overstap wanneer bestaande Herdr-sessies mogen worden afgesloten. Het wisselen van de symlink stopt bestaande processen niet; die blijven hun eerder gestarte versie draaien. Houd client- en serverversies op elkaar afgestemd.

Wanneer de gewone `herdr`-formule geïnstalleerd is:

```sh
brew unlink herdr
brew link --force asjer/versions/herdr@0.9.3
herdr --version
```

Zonder bestaande `herdr`-installatie is alleen de tweede opdracht nodig. Bij een linkconflict eerst onderzoeken welk pakket het bestand beheert; niet blind overschrijven.

## Via nix-darwin

Voeg `"asjer/versions"` toe aan `homebrew.taps` en vervang de gewone `"herdr"`-declaratie door:

```nix
homebrew.brews = [
  {
    name = "asjer/versions/herdr@0.9.3";
    link = true;
    conflicts_with = [ "herdr" ];
  }
];
```

`link = true` maakt deze keg-only versie het standaardcommando. Homebrew Bundle ontkoppelt de conflicterende gewone formule vóór installatie. Bij een configuratie met tap-trustbeheer moet de nieuwe tap ook in de declaratieve vertrouwenslijst staan.

## Updates en terugzetten

`brew upgrade` schakelt niet over naar de gewone `herdr` of een andere versienaam. Er is geen extra `brew pin` nodig. Een eventuele formule-revisie kan binnen dezelfde upstreamversie nog wel worden geïnstalleerd.

Een nieuwe upstreamversie krijgt een **nieuw formulebestand**; de versie en release-checksums van een bestaand bestand blijven vast. Onderliggende platformvereisten blijven die van de officiële releasebestanden.

Om terug te gaan naar de nieuwste Herdr, vervang je de versioned declaratie door een entry met `name = "herdr";` en `conflicts_with = [ "asjer/versions/herdr@0.9.3" ];`, zodat Bundle eerst de oude versie ontkoppelt. Bij handmatig Homebrew-gebruik:

```sh
brew unlink asjer/versions/herdr@0.9.3
brew install herdr
brew link herdr
```

## Validatie

```sh
brew style Formula/herdr@0.9.3.rb test/formula.rb
brew ruby test/formula.rb
brew audit --strict --os=all --arch=all asjer/versions/herdr@0.9.3
brew test asjer/versions/herdr@0.9.3
```

Voor audit moet de tap geïnstalleerd zijn; voor `brew test` ook de formule. CI installeert en test op macOS en Linux. De metadata-test controleert daarnaast alle vier platform-/architectuurcombinaties. De formule-test gebruikt een tijdelijke configuratie en start geen server.
