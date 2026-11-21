# OWASP NodeGoat lab with Docker Compose: practise the OWASP Top 10 in a deliberately insecure Node.js app

[![check](https://github.com/mitsurutech/lab-nodegoat/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-nodegoat/actions/workflows/check.yml)

A ready-made **web application security lab** for classrooms, from the [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning), where schools and colleges give every student their own databases, containers and terminal in the browser. Each student gets their own copy of **OWASP NodeGoat**, a retirement savings website written in **Node.js with MongoDB** that has the **OWASP Top 10** weaknesses built in, to practise **injection, broken authentication, insecure direct object references, cross-site scripting** and more, with NodeGoat's own tutorial beside each one showing the fixed code. Nothing is installed and nobody else's machine is at risk.

It is one `docker-compose` file, `compose.yaml`, and it runs the same on your own machine as it does on the platform, where every student gets a private copy with no way out to the internet. The help manual's page for this lab is [mitsurutech.co.uk/help/lab-nodegoat](https://mitsurutech.co.uk/help/lab-nodegoat).

## The one rule

**Attack your own copy and nothing else.** Everything in this lab runs inside your own private copy, which has no route to the internet and none to any other student, so the only thing you can reach is the application the lab started for you. Never point a tool at a website, a network or a machine you do not own, in a lab or anywhere else: in the UK that is an offence under the [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), and most countries have a law like it. Learning how weaknesses work is how you build software that does not have them, and a good first conversation in a class is why this rule exists and what responsible disclosure looks like.

## What is in it

| Service | Image | Memory | What it is |
| --- | --- | --- | --- |
| `nodegoat` | `ghcr.io/mitsurutech/nodegoat`, pinned by digest | 256 MB | OWASP NodeGoat, the website on port 4000 |
| `mongo` | [`mongo:4.4.30`](https://hub.docker.com/_/mongo) | 512 MB | the database NodeGoat stores its users and savings in |

NodeGoat starts in about four seconds with its images already downloaded and the two services use roughly 85 MB together when idle. The lab resets the database each time it starts, with NodeGoat's own `artifacts/db-reset.js`, and only then reports itself ready, so "ready" means you can sign in.

### Where the NodeGoat image comes from

**NodeGoat publishes no image of its own**, so this repository builds one. It is [OWASP NodeGoat](https://github.com/OWASP/NodeGoat) at one upstream commit, `c5cb68a7084e4ae7dcc60e6a98768720a81841e8` (the tip of its `master` on 15 October 2026, after version 1.3), built with **NodeGoat's own `Dockerfile`**, and published by the workflow in `.github/workflows/image.yml` as `ghcr.io/mitsurutech/nodegoat:1.3.0-c5cb68a`. The compose file pulls it **by digest**, so it cannot change under a class between one lesson and the next.

**It is unmodified.** Not one line of NodeGoat's source or its Dockerfile is changed: the list of changes made to make it run is empty. The only things added are the image's labels (title, source, revision and licence), and the way the lab starts it, which is in `compose.yaml` and not in the image: a start command that resets the database and then runs `node server.js`, and a healthcheck. NodeGoat is licensed under the [Apache License 2.0](https://github.com/OWASP/NodeGoat/blob/master/LICENSE), which allows redistribution. Its `LICENSE` is inside the image, at `/home/node/app/LICENSE`, and beside the build as [`image/UPSTREAM-LICENSE`](image/UPSTREAM-LICENSE); upstream ships no `NOTICE` file. NodeGoat is the work of the OWASP community and is not our product: this repository is only a way to run it in a lab.

MongoDB's own public image is used as it is. The Node.js base image NodeGoat's Dockerfile names is old (Node 12) and that is part of what the application is: update it and the application may stop working, and a lab whose application never changes is what a class needs.

## Using it on the platform

The [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning) gives every student their own copy of a lab, in the browser, with a terminal beside it.

**To try it:** open the [container page](https://mitsurutech.co.uk/container), find this lab in **Sample labs** and press Start. No account is needed to try one.

**To set it as work for a class:**

1. In your module, make a task of type **Lab** and choose **In a GitHub repository**.
2. Give `https://github.com/mitsurutech/lab-nodegoat` with the branch `main`. The compose file is the default, `compose.yaml`. Fork the repository first if you want to change the file.
3. Publish. Every student's copy starts from the commit you published, so a later change here does not alter a lab already set.
4. Say in the task what to hand in (see [For teachers](#for-teachers)), and assign it like any other task.

The help manual's [guide to the security labs](https://mitsurutech.co.uk/help/security-labs) and its [guide to container labs](https://mitsurutech.co.uk/help/labs) cover the rest: what a compose file may say, how much memory a copy gets, and how a teacher opens, watches and marks a student's copy. The [labs overview](https://mitsurutech.co.uk/help/labs) lists the other sample labs too.

No college account yet? [Your first year is free](https://mitsurutech.co.uk/pricing) for up to 50 students, and [signing up](https://mitsurutech.co.uk/signup) takes an email address.

## Running it on your own machine

You need Docker with the Compose plugin. The first start downloads the images.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Open <http://localhost:4000> and sign in as `user1` with the password `User1_123`. The administrator is `admin` with `Admin_123`, and `user2` has `User2_123`.

`local.yaml` publishes the port on `127.0.0.1` only, so the lab is reachable from your own computer and from nowhere else. Stop it with `Ctrl-C`, and remove it with `docker compose -f compose.yaml -f local.yaml down -v`. Run it on a machine you are happy to attack from: the application is insecure on purpose.

## Working through it

1. **Sign in** as `user1`. The database is already made, so there is nothing to set up. NodeGoat's sign-in page has a **Tutorial Guide** link to its own tutorial.
2. **Pick a weakness.** The tutorial follows the OWASP Top 10: injection (including server-side JavaScript injection on the Contributions page), broken authentication and session management, cross-site scripting, insecure direct object references (change the number at the end of the Allocations address), security misconfiguration, sensitive data exposure, missing access control, cross-site request forgery, components with known vulnerabilities and unvalidated redirects, with two more tutorials on server-side request forgery and regular expression denial of service.
3. **Exploit it, then read the fix.** Each tutorial page shows the vulnerable code and the fixed code, and the source carries the fix as a comment beside the weakness.
4. **Start again when you want to.** Stopping and starting the lab gives a fresh database, which is also the way back from a page you broke. Some exercises, such as the tutorial's regular expression denial of service one, are meant to hurt the server.

## For teachers

Nothing in this lab is marked automatically. The student hands in evidence and you mark it, the way you mark any other lab.

**Ask for evidence in two halves.** First, proof of the work: a screenshot of each weakness used, with the lab's own address visible in the browser so it is clearly their copy. Second, the understanding: for each one, a written explanation in their own words of what the weakness is, the exact input they used and why it worked, what an attacker could do with it, and how the code should have been written. The second half tells you whether it was understood or copied from a walkthrough. For stronger work ask for the fix as well as the attack.

**Where it sits in a course.** NodeGoat suits secure coding and the OWASP Top 10 in a web development or cyber security unit: access control, authentication, input handling and output encoding, in an application written in JavaScript that a web student can read. It also supports the legal and ethical side of a unit: authorisation and scope, the Computer Misuse Act 1990 and responsible disclosure. Check your own awarding body's unit for the exact wording; none is quoted here.

**Who sees what.** These labs are often used with students aged 16 and 17. A copy is private to the student who started it. A member of staff who teaches the module can open it to see what the student has done, and opening a student's work is written to the access log, which the student can read.

## What does not work in a lab

The lab has no way out to the internet at all. The Learning Resources page links to external websites and shows nothing a lab can reach, and exercises that fetch an address on the internet (the server-side request forgery one in the tutorial) can only reach the lab's own services. NodeGoat is given 256 MB and its database 512 MB. The database is not saved: nothing is kept when the lab stops.

## Troubleshooting

- **The sign-in page does not appear straight after Start.** Wait a few seconds and press Open again: the lab reports itself ready only once the database has been made.
- **The site stops answering after an exercise.** Some exercises crash the server on purpose. Stop the lab and start it again for a fresh copy.
- **On your own machine, port 4000 is already in use.** Change the left-hand number in `local.yaml`, for example `127.0.0.1:4001:4000`, and open that port instead.

## About

This lab is made by [Mitsuru Technologies Ltd](https://mitsurutech.co.uk), the company behind the [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning): a place for teachers to set coding, databases, containers and lab work and mark what students hand in. The files in this repository that we wrote (the compose file, the tests and the workflow) are MIT licensed, see [LICENSE](LICENSE); OWASP NodeGoat is Apache-2.0 licensed and belongs to its authors.

Other labs in the same series, each its own repository and each with a [page in the manual](https://mitsurutech.co.uk/help/labs):

- [lab-dvwa](https://github.com/mitsurutech/lab-dvwa): DVWA, the Damn Vulnerable Web Application
- [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop): OWASP Juice Shop
- [lab-webgoat](https://github.com/mitsurutech/lab-webgoat): OWASP WebGoat and WebWolf
- [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin): MySQL and phpMyAdmin
- [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea): Git and Gitea
- [lab-sample](https://github.com/mitsurutech/lab-sample): PostgreSQL and PostgREST

## About the passwords in this repository

The accounts above (`user1`, `user2`, `admin`) are NodeGoat's own published demo accounts. They are fixtures for a lab that runs only on your own computer or inside the platform, never real credentials, and they are written here on purpose.
