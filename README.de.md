# OWASP-NodeGoat-Lab mit Docker Compose: die OWASP Top 10 in einer absichtlich unsicheren Node.js-App üben

[English](README.md) | [Français](README.fr.md) | [Español](README.es.md) | [日本語](README.ja.md) | [Deutsch](README.de.md)

[![check](https://github.com/mitsurutech/lab-nodegoat/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-nodegoat/actions/workflows/check.yml)

Ein fertiges **Lab für Webanwendungssicherheit** für den Unterricht von der [MitsuruTech Learning Platform](https://mitsurutech.co.uk/de/learning), auf der Schulen und Colleges allen Lernenden eigene Datenbanken, Container und ein Terminal im Browser geben. Alle Lernenden bekommen eine eigene Kopie von **OWASP NodeGoat**, einer Website für die Altersvorsorge, geschrieben in **Node.js mit MongoDB**, in die die Schwachstellen der **OWASP Top 10** eingebaut sind, um **Injection, fehlerhafte Authentifizierung, unsichere direkte Objektreferenzen, Cross-Site-Scripting** und mehr zu üben, neben jeder Schwachstelle das Tutorial von NodeGoat selbst mit dem behobenen Code. Nichts wird installiert, und kein fremder Rechner ist in Gefahr.

Es ist eine einzige `docker-compose`-Datei, `compose.yaml`, und läuft auf dem eigenen Rechner genauso wie auf der Plattform, wo alle Lernenden eine private Kopie ohne Weg ins Internet bekommen. Die Seite des Hilfehandbuchs zu diesem Lab ist [mitsurutech.co.uk/help/lab-nodegoat](https://mitsurutech.co.uk/help/lab-nodegoat).

## Die eine Regel

**Greifen Sie Ihre eigene Kopie an und sonst nichts.** Alles in diesem Lab läuft in Ihrer eigenen privaten Kopie, die keinen Weg ins Internet und keinen zu anderen Lernenden hat, sodass Sie nur die Anwendung erreichen, die das Lab für Sie gestartet hat. Richten Sie nie ein Werkzeug auf eine Website, ein Netz oder einen Rechner, der Ihnen nicht gehört, weder in einem Lab noch anderswo: Im Vereinigten Königreich ist das eine Straftat nach dem [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), und die meisten Länder haben ein ähnliches Gesetz. Zu lernen, wie Schwachstellen funktionieren, ist der Weg zu Software, die keine hat, und ein gutes erstes Gespräch in einer Klasse ist, warum es diese Regel gibt und wie verantwortungsvolle Offenlegung aussieht.

## Was darin ist

| Dienst | Image | Speicher | Was es ist |
| --- | --- | --- | --- |
| `nodegoat` | `ghcr.io/mitsurutech/nodegoat`, per Digest festgelegt | 256 MB | OWASP NodeGoat, die Website auf Port 4000 |
| `mongo` | [`mongo:4.4.30`](https://hub.docker.com/_/mongo) | 512 MB | die Datenbank, in der NodeGoat seine Nutzer und ihre Ersparnisse speichert |

NodeGoat startet in etwa vier Sekunden, wenn die Images bereits heruntergeladen sind, und die beiden Dienste brauchen im Leerlauf zusammen ungefähr 85 MB. Das Lab setzt die Datenbank bei jedem Start mit NodeGoats eigenem `artifacts/db-reset.js` zurück und meldet sich erst danach als bereit, „bereit“ heißt also, dass Sie sich anmelden können.

### Woher das NodeGoat-Image kommt

**NodeGoat veröffentlicht kein eigenes Image**, deshalb baut dieses Repository eines. Es ist [OWASP NodeGoat](https://github.com/OWASP/NodeGoat) auf einem Commit des Originalprojekts, `c5cb68a7084e4ae7dcc60e6a98768720a81841e8` (die Spitze seines `master` am 15. Oktober 2026, nach Version 1.3), gebaut mit **NodeGoats eigenem `Dockerfile`** und vom Workflow in `.github/workflows/image.yml` als `ghcr.io/mitsurutech/nodegoat:1.3.0-c5cb68a` veröffentlicht. Die Compose-Datei lädt es **per Digest**, damit es sich zwischen zwei Lektionen nicht unter einer Klasse verändern kann.

**Es ist unverändert.** Keine Zeile von NodeGoats Quellcode oder seinem Dockerfile ist geändert: Die Liste der Änderungen, die nötig waren, damit es läuft, ist leer. Hinzugefügt sind nur die Labels des Images (Titel, Quelle, Revision und Lizenz) und die Art, wie das Lab es startet, die in `compose.yaml` steht und nicht im Image: ein Startbefehl, der die Datenbank zurücksetzt und dann `node server.js` ausführt, und ein Healthcheck. NodeGoat steht unter der [Apache License 2.0](https://github.com/OWASP/NodeGoat/blob/master/LICENSE), die die Weitergabe erlaubt. Seine `LICENSE` liegt im Image unter `/home/node/app/LICENSE` und neben dem Build als [`image/UPSTREAM-LICENSE`](image/UPSTREAM-LICENSE); das Originalprojekt liefert keine `NOTICE`-Datei. NodeGoat ist das Werk der OWASP-Community und nicht unser Produkt: Dieses Repository ist nur ein Weg, es in einem Lab zu betreiben.

Das eigene öffentliche Image von MongoDB wird unverändert verwendet. Das Node.js-Basis-Image, das NodeGoats Dockerfile nennt, ist alt (Node 12), und das gehört zu dem, was die Anwendung ist: Aktualisiert man es, funktioniert die Anwendung womöglich nicht mehr, und ein Lab, dessen Anwendung sich nie ändert, ist das, was eine Klasse braucht.

## Verwendung auf der Plattform

Die [MitsuruTech Learning Platform](https://mitsurutech.co.uk/de/learning) gibt allen Lernenden eine eigene Kopie eines Labs im Browser, mit einem Terminal daneben.

**Zum Ausprobieren:** Öffnen Sie die [Container-Seite](https://mitsurutech.co.uk/de/container), suchen Sie dieses Lab unter **Sample labs** und drücken Sie Start. Zum Ausprobieren ist kein Konto nötig.

**Als Aufgabe für eine Klasse:**

1. Legen Sie in Ihrem Modul eine Aufgabe vom Typ **Lab** an und wählen Sie **In a GitHub repository**.
2. Geben Sie `https://github.com/mitsurutech/lab-nodegoat` mit dem Branch `main` an. Die Compose-Datei ist die Vorgabe, `compose.yaml`. Forken Sie das Repository zuerst, wenn Sie die Datei ändern möchten.
3. Veröffentlichen Sie. Jede Kopie startet von dem Commit, den Sie veröffentlicht haben, sodass eine spätere Änderung hier ein bereits gestelltes Lab nicht verändert.
4. Schreiben Sie in die Aufgabe, was abzugeben ist (siehe [Für Lehrkräfte](#für-lehrkräfte)), und weisen Sie sie wie jede andere Aufgabe zu.

Der [Leitfaden zu den Sicherheits-Labs](https://mitsurutech.co.uk/de/help/security-labs) im Hilfehandbuch und sein [Leitfaden zu Container-Labs](https://mitsurutech.co.uk/de/help/labs) erklären den Rest: was eine Compose-Datei enthalten darf, wie viel Speicher eine Kopie bekommt und wie eine Lehrkraft die Kopie von Lernenden öffnet, beobachtet und bewertet. Die [Übersicht der Labs](https://mitsurutech.co.uk/de/help/labs) listet auch die anderen Beispiel-Labs.

Noch kein College-Konto? [Das erste Jahr ist kostenlos](https://mitsurutech.co.uk/de/pricing) für bis zu 50 Lernende, und für die [Anmeldung](https://mitsurutech.co.uk/de/signup) genügt eine E-Mail-Adresse.

## Auf dem eigenen Rechner ausführen

Sie brauchen Docker mit dem Compose-Plugin. Beim ersten Start werden die Images heruntergeladen.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Öffnen Sie <http://localhost:4000> und melden Sie sich als `user1` mit dem Passwort `User1_123` an. Der Administrator ist `admin` mit `Admin_123`, und `user2` hat `User2_123`.

`local.yaml` veröffentlicht den Port nur auf `127.0.0.1`, sodass das Lab nur von Ihrem eigenen Rechner aus erreichbar ist. Stoppen Sie es mit `Ctrl-C` und entfernen Sie es mit `docker compose -f compose.yaml -f local.yaml down -v`. Führen Sie es auf einem Rechner aus, von dem aus Sie bedenkenlos angreifen können: Die Anwendung ist absichtlich unsicher.

## Durcharbeiten

1. **Melden Sie sich** als `user1` an. Die Datenbank ist schon angelegt, es gibt also nichts einzurichten. NodeGoats Anmeldeseite hat einen Link **Tutorial Guide** zu seinem eigenen Tutorial.
2. **Wählen Sie eine Schwachstelle.** Das Tutorial folgt den OWASP Top 10: Injection (einschließlich serverseitiger JavaScript-Injection auf der Seite Contributions), fehlerhafte Authentifizierung und Sitzungsverwaltung, Cross-Site-Scripting, unsichere direkte Objektreferenzen (ändern Sie die Zahl am Ende der Adresse von Allocations), Sicherheitsfehlkonfiguration, Offenlegung sensibler Daten, fehlende Zugriffskontrolle, Cross-Site Request Forgery, Komponenten mit bekannten Schwachstellen und unvalidierte Weiterleitungen, dazu zwei weitere Tutorials zu Server-Side Request Forgery und Denial of Service durch reguläre Ausdrücke.
3. **Nutzen Sie sie aus und lesen Sie dann die Behebung.** Jede Seite des Tutorials zeigt den verwundbaren und den behobenen Code, und der Quellcode trägt die Behebung als Kommentar neben der Schwachstelle.
4. **Fangen Sie neu an, wann Sie wollen.** Stoppen und erneutes Starten des Labs ergibt eine frische Datenbank, und das ist auch der Weg zurück von einer Seite, die Sie kaputt gemacht haben. Manche Übungen, etwa die zu Denial of Service durch reguläre Ausdrücke im Tutorial, sollen dem Server schaden.

## Für Lehrkräfte

In diesem Lab wird nichts automatisch bewertet. Die Lernenden geben Belege ab, und Sie bewerten sie, wie jedes andere Lab.

**Verlangen Sie Belege in zwei Teilen.** Erstens den Nachweis der Arbeit: einen Screenshot jeder genutzten Schwachstelle, auf dem die Adresse des Labs im Browser zu sehen ist, damit klar ist, dass es die eigene Kopie ist. Zweitens das Verständnis: für jede Schwachstelle eine schriftliche Erklärung in eigenen Worten, was die Schwachstelle ist, welche Eingabe genau verwendet wurde und warum sie funktioniert hat, was ein Angreifer damit tun könnte und wie der Code hätte geschrieben werden sollen. Der zweite Teil zeigt Ihnen, ob etwas verstanden oder aus einer Musterlösung abgeschrieben wurde. Für anspruchsvollere Arbeiten verlangen Sie die Behebung zusätzlich zum Angriff.

**Wo es in einen Kurs passt.** NodeGoat eignet sich für sichere Programmierung und die OWASP Top 10 in einer Einheit zu Webentwicklung oder Cybersicherheit: Zugriffskontrolle, Authentifizierung, Umgang mit Eingaben und Kodierung von Ausgaben, in einer in JavaScript geschriebenen Anwendung, die Lernende aus dem Webbereich lesen können. Es unterstützt auch die rechtliche und ethische Seite einer Einheit: Autorisierung und Umfang, den Computer Misuse Act 1990 und verantwortungsvolle Offenlegung. Prüfen Sie den genauen Wortlaut in der Einheit Ihrer eigenen Prüfungsstelle; hier wird keine zitiert.

**Wer was sieht.** Diese Labs werden oft mit Lernenden im Alter von 16 und 17 Jahren genutzt. Eine Kopie ist privat für die Person, die sie gestartet hat. Ein Mitglied des Personals, das das Modul unterrichtet, kann sie öffnen, um zu sehen, was die Person getan hat, und das Öffnen der Arbeit von Lernenden wird ins Zugriffsprotokoll geschrieben, das die Lernenden lesen können.

## Was in einem Lab nicht geht

Das Lab hat überhaupt keinen Weg ins Internet. Die Seite Learning Resources verlinkt auf externe Websites und zeigt nichts, was ein Lab erreichen kann, und Übungen, die eine Adresse im Internet abrufen (die zu Server-Side Request Forgery im Tutorial), erreichen nur die eigenen Dienste des Labs. NodeGoat bekommt 256 MB und seine Datenbank 512 MB. Die Datenbank wird nicht gespeichert: Wenn das Lab stoppt, bleibt nichts erhalten.

## Fehlerbehebung

- **Die Anmeldeseite erscheint nicht direkt nach Start.** Warten Sie einige Sekunden und drücken Sie erneut Open: Das Lab meldet sich erst als bereit, wenn die Datenbank angelegt ist.
- **Die Website antwortet nach einer Übung nicht mehr.** Manche Übungen bringen den Server absichtlich zum Absturz. Stoppen Sie das Lab und starten Sie es neu, dann haben Sie eine frische Kopie.
- **Auf dem eigenen Rechner ist Port 4000 schon belegt.** Ändern Sie die linke Zahl in `local.yaml`, zum Beispiel auf `127.0.0.1:4001:4000`, und öffnen Sie stattdessen diesen Port.

## Über uns

Dieses Lab stammt von [Mitsuru Technologies Ltd](https://mitsurutech.co.uk/de), dem Unternehmen hinter der [MitsuruTech Learning Platform](https://mitsurutech.co.uk/de/learning): ein Ort, an dem Lehrkräfte Aufgaben zu Programmierung, Datenbanken, Containern und Labs stellen und bewerten, was Lernende abgeben. Die Dateien in diesem Repository, die wir geschrieben haben (die Compose-Datei, die Tests und der Workflow), stehen unter der MIT-Lizenz, siehe [LICENSE](LICENSE); OWASP NodeGoat steht unter Apache-2.0 und gehört seinen Autoren.

Weitere Labs derselben Reihe, jedes in einem eigenen Repository und jedes mit einer [Seite im Handbuch](https://mitsurutech.co.uk/de/help/labs):

- [lab-dvwa](https://github.com/mitsurutech/lab-dvwa): DVWA, die Damn Vulnerable Web Application
- [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop): OWASP Juice Shop
- [lab-webgoat](https://github.com/mitsurutech/lab-webgoat): OWASP WebGoat und WebWolf
- [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin): MySQL und phpMyAdmin
- [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea): Git und Gitea
- [lab-sample](https://github.com/mitsurutech/lab-sample): PostgreSQL und PostgREST

## Zu den Passwörtern in diesem Repository

Die obigen Konten (`user1`, `user2`, `admin`) sind die von NodeGoat selbst veröffentlichten Demokonten. Sie sind Übungsvorgaben für ein Lab, das nur auf Ihrem eigenen Rechner oder in der Plattform läuft, niemals echte Zugangsdaten, und sie stehen hier absichtlich.
