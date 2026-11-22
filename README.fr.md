# Labo OWASP NodeGoat avec Docker Compose : s'exercer au Top 10 de l'OWASP dans une application Node.js volontairement vulnérable

[English](README.md) | [Français](README.fr.md) | [Español](README.es.md) | [日本語](README.ja.md) | [Deutsch](README.de.md)

[![check](https://github.com/mitsurutech/lab-nodegoat/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-nodegoat/actions/workflows/check.yml)

Un **labo de sécurité des applications web** prêt à l'emploi pour la classe, issu de la [plateforme d'apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning), où les écoles et les lycées donnent à chaque élève ses propres bases de données, conteneurs et terminal dans le navigateur. Chaque élève reçoit sa propre copie d'**OWASP NodeGoat**, un site d'épargne retraite écrit en **Node.js avec MongoDB** qui intègre les faiblesses du **Top 10 de l'OWASP**, pour s'exercer à **l'injection, l'authentification défaillante, les références directes non sécurisées à des objets, le cross-site scripting** et plus encore, avec à côté de chacune le tutoriel de NodeGoat qui montre le code corrigé. Rien n'est installé et la machine de personne d'autre n'est en danger.

C'est un seul fichier `docker-compose`, `compose.yaml`, et il fonctionne de la même façon sur votre machine que sur la plateforme, où chaque élève reçoit une copie privée sans accès à internet. La page du manuel d'aide consacrée à ce labo est [mitsurutech.co.uk/help/lab-nodegoat](https://mitsurutech.co.uk/help/lab-nodegoat).

## La seule règle

**Attaquez votre propre copie et rien d'autre.** Tout dans ce labo tourne à l'intérieur de votre copie privée, qui n'a aucune route vers internet ni vers un autre élève : la seule chose que vous pouvez atteindre est l'application que le labo a lancée pour vous. Ne pointez jamais un outil vers un site web, un réseau ou une machine qui ne vous appartient pas, dans un labo ou ailleurs : au Royaume-Uni, c'est une infraction au titre du [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), et la plupart des pays ont une loi semblable. Comprendre comment fonctionnent les faiblesses, c'est ainsi qu'on écrit des logiciels qui n'en ont pas, et une bonne première discussion en classe porte sur la raison d'être de cette règle et sur ce qu'est une divulgation responsable.

## Ce qu'il contient

| Service | Image | Mémoire | Ce que c'est |
| --- | --- | --- | --- |
| `nodegoat` | `ghcr.io/mitsurutech/nodegoat`, épinglée par son digest | 256 Mo | OWASP NodeGoat, le site sur le port 4000 |
| `mongo` | [`mongo:4.4.30`](https://hub.docker.com/_/mongo) | 512 Mo | la base de données où NodeGoat range ses utilisateurs et leur épargne |

NodeGoat démarre en quatre secondes environ une fois les images téléchargées, et les deux services utilisent à peu près 85 Mo à eux deux au repos. Le labo réinitialise la base de données à chaque démarrage, avec le propre `artifacts/db-reset.js` de NodeGoat, et ne se déclare prêt qu'ensuite : « prêt » veut donc dire que vous pouvez vous connecter.

### D'où vient l'image de NodeGoat

**NodeGoat ne publie aucune image à lui**, alors ce dépôt en construit une. C'est [OWASP NodeGoat](https://github.com/OWASP/NodeGoat) à un commit précis du projet d'origine, `c5cb68a7084e4ae7dcc60e6a98768720a81841e8` (la pointe de sa branche `master` le 15 octobre 2026, après la version 1.3), construit avec **le propre `Dockerfile` de NodeGoat**, et publié par le workflow de `.github/workflows/image.yml` sous le nom `ghcr.io/mitsurutech/nodegoat:1.3.0-c5cb68a`. Le fichier compose la récupère **par son digest**, elle ne peut donc pas changer sous les pieds d'une classe entre deux leçons.

**Elle n'est pas modifiée.** Pas une ligne du code source de NodeGoat ni de son Dockerfile n'est changée : la liste des modifications faites pour le faire tourner est vide. Les seuls ajouts sont les étiquettes de l'image (titre, source, révision et licence) et la façon dont le labo la démarre, qui se trouve dans `compose.yaml` et non dans l'image : une commande de démarrage qui réinitialise la base puis lance `node server.js`, et un healthcheck. NodeGoat est sous [licence Apache 2.0](https://github.com/OWASP/NodeGoat/blob/master/LICENSE), qui autorise la redistribution. Son `LICENSE` se trouve dans l'image, à `/home/node/app/LICENSE`, et à côté de la construction sous [`image/UPSTREAM-LICENSE`](image/UPSTREAM-LICENSE) ; le projet d'origine ne fournit pas de fichier `NOTICE`. NodeGoat est l'œuvre de la communauté OWASP et n'est pas notre produit : ce dépôt n'est qu'un moyen de le faire tourner dans un labo.

L'image publique officielle de MongoDB est utilisée telle quelle. L'image de base Node.js que nomme le Dockerfile de NodeGoat est ancienne (Node 12), et cela fait partie de ce qu'est l'application : mettez-la à jour et l'application risque de ne plus fonctionner, or un labo dont l'application ne change jamais, c'est ce dont une classe a besoin.

## Utilisation sur la plateforme

La [plateforme d'apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning) donne à chaque élève sa propre copie d'un labo, dans le navigateur, avec un terminal à côté.

**Pour l'essayer :** ouvrez la [page des conteneurs](https://mitsurutech.co.uk/fr/container), trouvez ce labo dans **Sample labs** et appuyez sur Start. Aucun compte n'est nécessaire pour en essayer un.

**Pour le donner en travail à une classe :**

1. Dans votre module, créez une tâche de type **Lab** et choisissez **In a GitHub repository**.
2. Indiquez `https://github.com/mitsurutech/lab-nodegoat` avec la branche `main`. Le fichier compose est celui par défaut, `compose.yaml`. Faites d'abord un fork du dépôt si vous voulez modifier le fichier.
3. Publiez. La copie de chaque élève part du commit que vous avez publié, donc une modification ultérieure ici ne change pas un labo déjà donné.
4. Précisez dans la tâche ce qu'il faut rendre (voir [Pour les enseignants](#pour-les-enseignants)), et attribuez-la comme n'importe quelle autre tâche.

Le [guide des labos de sécurité](https://mitsurutech.co.uk/fr/help/security-labs) du manuel d'aide et son [guide des labos en conteneur](https://mitsurutech.co.uk/fr/help/labs) expliquent le reste : ce qu'un fichier compose peut contenir, combien de mémoire reçoit une copie, et comment un enseignant ouvre, suit et note la copie d'un élève. La [vue d'ensemble des labos](https://mitsurutech.co.uk/fr/help/labs) liste aussi les autres labos d'exemple.

Pas encore de compte d'établissement ? [La première année est gratuite](https://mitsurutech.co.uk/fr/pricing) jusqu'à 50 élèves, et [l'inscription](https://mitsurutech.co.uk/fr/signup) ne demande qu'une adresse e-mail.

## L'exécuter sur votre propre machine

Il vous faut Docker avec le plugin Compose. Le premier démarrage télécharge les images.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Ouvrez <http://localhost:4000> et connectez-vous en tant que `user1` avec le mot de passe `User1_123`. L'administrateur est `admin` avec `Admin_123`, et `user2` a `User2_123`.

`local.yaml` ne publie le port que sur `127.0.0.1` : le labo n'est joignable que depuis votre ordinateur. Arrêtez-le avec `Ctrl-C` et supprimez-le avec `docker compose -f compose.yaml -f local.yaml down -v`. Lancez-le sur une machine depuis laquelle vous acceptez d'attaquer : l'application est volontairement vulnérable.

## Le parcours

1. **Connectez-vous** en tant que `user1`. La base de données est déjà créée, il n'y a donc rien à préparer. La page de connexion de NodeGoat a un lien **Tutorial Guide** vers son propre tutoriel.
2. **Choisissez une faiblesse.** Le tutoriel suit le Top 10 de l'OWASP : l'injection (y compris l'injection de JavaScript côté serveur sur la page Contributions), l'authentification et la gestion de session défaillantes, le cross-site scripting, les références directes non sécurisées à des objets (changez le nombre à la fin de l'adresse de la page Allocations), la mauvaise configuration de sécurité, l'exposition de données sensibles, l'absence de contrôle d'accès, la falsification de requête intersite, les composants aux vulnérabilités connues et les redirections non validées, avec deux tutoriels de plus sur la falsification de requête côté serveur et le déni de service par expression régulière.
3. **Exploitez-la, puis lisez le correctif.** Chaque page du tutoriel montre le code vulnérable et le code corrigé, et le code source porte le correctif en commentaire à côté de la faiblesse.
4. **Recommencez quand vous voulez.** Arrêter puis redémarrer le labo donne une base de données neuve, ce qui est aussi le moyen de revenir d'une page que vous avez cassée. Certains exercices, comme celui du tutoriel sur le déni de service par expression régulière, sont faits pour mettre le serveur à mal.

## Pour les enseignants

Rien dans ce labo n'est noté automatiquement. L'élève rend des preuves et vous les notez, comme pour n'importe quel autre labo.

**Demandez des preuves en deux parties.** D'abord, la preuve du travail : une capture d'écran de chaque faiblesse exploitée, avec l'adresse du labo visible dans le navigateur pour qu'on voie bien que c'est sa copie. Ensuite, la compréhension : pour chacune, une explication écrite avec ses propres mots de ce qu'est la faiblesse, de la saisie exacte utilisée et de la raison pour laquelle elle a fonctionné, de ce qu'un attaquant pourrait en faire, et de la façon dont le code aurait dû être écrit. La seconde partie vous dit si c'est compris ou recopié d'un corrigé trouvé en ligne. Pour un travail plus poussé, demandez le correctif en plus de l'attaque.

**Sa place dans un cursus.** NodeGoat convient au codage sécurisé et au Top 10 de l'OWASP dans un module de développement web ou de cybersécurité : contrôle d'accès, authentification, traitement des entrées et encodage des sorties, dans une application écrite en JavaScript qu'un élève en web sait lire. Il sert aussi le volet juridique et éthique d'un module : autorisation et périmètre, le Computer Misuse Act 1990 et la divulgation responsable. Vérifiez la formulation exacte dans le référentiel de votre propre organisme certificateur ; aucun n'est cité ici.

**Qui voit quoi.** Ces labos sont souvent utilisés avec des élèves de 16 et 17 ans. Une copie est privée pour l'élève qui l'a lancée. Un membre du personnel qui enseigne dans le module peut l'ouvrir pour voir ce que l'élève a fait, et l'ouverture du travail d'un élève est inscrite au journal d'accès, que l'élève peut lire.

## Ce qui ne fonctionne pas dans un labo

Le labo n'a aucun accès à internet. La page Learning Resources renvoie vers des sites externes et n'affiche rien qu'un labo puisse atteindre, et les exercices qui vont chercher une adresse sur internet (celui du tutoriel sur la falsification de requête côté serveur) ne peuvent atteindre que les services du labo. NodeGoat reçoit 256 Mo et sa base de données 512 Mo. La base de données n'est pas conservée : rien n'est gardé à l'arrêt du labo.

## Dépannage

- **La page de connexion n'apparaît pas juste après Start.** Attendez quelques secondes et appuyez de nouveau sur Open : le labo ne se déclare prêt qu'une fois la base de données créée.
- **Le site ne répond plus après un exercice.** Certains exercices font planter le serveur exprès. Arrêtez le labo et redémarrez-le pour avoir une copie neuve.
- **Sur votre machine, le port 4000 est déjà utilisé.** Changez le nombre de gauche dans `local.yaml`, par exemple `127.0.0.1:4001:4000`, et ouvrez ce port à la place.

## À propos

Ce labo est réalisé par [Mitsuru Technologies Ltd](https://mitsurutech.co.uk/fr), l'entreprise derrière la [plateforme d'apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning) : un endroit où les enseignants donnent des travaux de code, de bases de données, de conteneurs et de labos, et notent ce que les élèves rendent. Les fichiers de ce dépôt que nous avons écrits (le fichier compose, les tests et le workflow) sont sous licence MIT, voir [LICENSE](LICENSE) ; OWASP NodeGoat est sous licence Apache-2.0 et appartient à ses auteurs.

Les autres labos de la même série, chacun dans son propre dépôt et chacun avec une [page dans le manuel](https://mitsurutech.co.uk/fr/help/labs) :

- [lab-dvwa](https://github.com/mitsurutech/lab-dvwa) : DVWA, la Damn Vulnerable Web Application
- [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop) : OWASP Juice Shop
- [lab-webgoat](https://github.com/mitsurutech/lab-webgoat) : OWASP WebGoat et WebWolf
- [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin) : MySQL et phpMyAdmin
- [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) : Git et Gitea
- [lab-sample](https://github.com/mitsurutech/lab-sample) : PostgreSQL et PostgREST

## À propos des mots de passe de ce dépôt

Les comptes ci-dessus (`user1`, `user2`, `admin`) sont les comptes de démonstration publiés par NodeGoat lui-même. Ce sont des données d'exercice pour un labo qui ne tourne que sur votre ordinateur ou dans la plateforme, jamais de véritables identifiants, et ils sont écrits ici exprès.
