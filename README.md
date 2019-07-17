# README

Il seguente progetto rails è una versione dimostrativa di come funziona il sistema SPID.

Per testare il funzionamento viene utilizzato l'Identity Provider di test [SPID-testenv2](https://github.com/italia/spid-testenv2)

## ATTENZIONE

Lo sviluppo del progetto è stato spostato su https://github.com/italia/spid-rails.
Questo repository non è stabile e mantenuto.

## Requisiti

Installare le seguenti librerie di sistema:

* [xmlsec1](http://www.aleksey.com/xmlsec/)

* [libffi-dev](http://sourceware.org/libffi/)

* [pip](https://www.makeuseof.com/tag/install-pip-for-python/)

## Istruzioni di installazione

1) Clonare in una nuova directory il presente repository
  ```
    $ git clone git@github.com:rubynetti/rubynetti-rails.git && cd rubynetti-rails && bundle install
  ```

2) Avviare il server
  ```
    bundle exec rails server -b 0.0.0.0
  ```

3) In un nuovo terminale, clonare il repository dell'Identity Provider

  ```
    $ git clone git@github.com:italia/spid-testenv2.git && cd spid-testenv2
  ```

4) Generare una nuova coppia chiave/certificato per l'Identity Provider

  ```
    $ openssl req -x509 -nodes -sha256 -days 365 -subj '/C=IT' -newkey rsa:4096 -keyout idp.key -out idp.crt
  ```

5) Creare un virtualenv di python
  ```
    $ virtualenv env
    $ source env/bin/activate
  ```

6) Installare le dipendenze
  ```
    $ pip install -r requirements.txt
  ```

7) Copiare il file di configurazione
  ```
    $ cp config.yaml.example config.yaml
  ```

8) Editare il file di configurazione scommentando nella sezione metadata
  ```
    metadata:
     remote:
     - url: "http://spid-sp/metadata/"
  ```

  e sostituire la riga ```url``` con la seguente:

  ```
    - url: "http://rubynetti.local:3000/spid/metadata"
  ```
9) Aggiungere i nomi dns in ```/etc/hosts```
  ```
    $ echo "127.0.0.1 spid-testenv" | sudo tee -a /etc/hosts
    $ echo "127.0.0.1 rubynetti.local" | sudo tee -a /etc/hosts
  ```

10) Avviare l'Identity Provider di test
  ```
    $ python spid-testenv.py
  ```

11) Creare un utente all'indirizzo "http://spid-testenv:8088/add-user", avendo cura di riportare nel campo "Service Provider ID" il valore "http://rubynetti.local:3000/" e
compilando gli attributi che si vuole fornire al service provide nell'Authn Assertion

12) Navigare all'indirizzo http://rubynetti.local:3000/ per visualizzare l'applicazione demo


## Rubynetti

Progetto sperimentale realizzato da [Rubynetti.it](https://www.rubynetti.it/)
