# swift-style-guide
Guida di riferimento per i progetti Swift gestiti da Tiknil e i suoi collaboratori.

L'obiettivo è darsi delle **best practices** sulla stesura del codice per agevolare il lavoro in team e velocizzare la comprensione del codice.

## Riferimenti
Linee guida da cui è stato preso spunto per scrivere questo documento:
* [RayWenderlich Swift style guide](https://github.com/raywenderlich/swift-style-guide)
* [Swift guidelines](https://swift.org/documentation/api-design-guidelines/)

In generale **Tiknil adotta tutte le linee guida di RayWenderlich** e in questo documento riportiamo quelle che consideriamo più importanti ed eventuali modifiche o integrazioni ad esse.

## Sommario
* [Naming](#naming)
  * [Lingua](#lingua)
  * [Case conventions](#case-conventions)
  * [Type inferred context](#type-inferred-context)
* [Organizzazione del codice](#organizzazione-del-codice)
  * [Implementazione di protocolli](#implementazione-di-protocolli)
  * [Codice inutilizzato](#codice-inutilizzato)
* [Indentazione](#indentazione)
* [Design pattern](#design-pattern)
  * [MVC](#mvc)
  * [MVVM](#mvvm)
  * [Inversion of Control e Dependency Injection](#inversion-of-control-e-dependency-injection)
  * [Flow coordinator](#flow-coordinator)
* [Struttura del progetto](#struttura-del-progetto)
  * [Repository e CocoaPods](#repository-e-cocoapods)
  * [Cartelle di progetto](#cartelle-di-progetto)
* [ReactiveX](#reactivex)
* [Esempio pratico](#esempio-pratico)

## Naming
Per facilitare la lettura del codice seguiamo i soprattutto i seguenti principi:
* chiarezza **>** brevità
* usare `CamelCase`, mai `snake_case`
* preferire metodi e proprietà a funzioni
* evitare overload di metodi modificando solo il tipo ritornato

### Lingua
Usare la lingua Inglese per il codice, quella Italiana per i commenti e la documentazione del codice (ove non espressamente richiesta la lingua inglese)

👍
```Swift
let myColor = UIColor.white
```

👎
```Swift
let mioColore = UIColor.white
```

### Case conventions
Tipi (classi) e protocolli in `UpperCamelCase`

Qualsiasi altra cosa in `LowerCamelCase`

👍
```Swift
class MyAwesomeClass { ... }
struct MyAwesomeStruct { ... }
let constant = "http://www.tiknil.com"
var variable = 3
```

👎
```Swift
class myAwesomeClass { ... }
struct my_awesome_struct { ... }
let _constant = "http://www.tiknil.com"
var Variable = 3
```

### Type inferred context
Ove possibile lasciare contestualizzare al compilatore per migliorare la leggibilità del codice.

👍
```Swift
let selector = #selector(viewDidLoad)
view.backgroundColor = .red
let toView = context.view(forKey: .to)
let view = UIView(frame: .zero)
```

👎
```Swift
let selector = #selector(ViewController.viewDidLoad)
view.backgroundColor = UIColor.red
let toView = context.view(forKey: UITransitionContextViewKey.to)
let view = UIView(frame: CGRect.zero)
```

## Organizzazione del codice
Nelle classi utilizzare lo [snippet di codice](https://github.com/tiknil/xcode-snippets) per la generazione dei `MARK` in modo da separare uniformemente il codice in tutte le classi secondo la seguente struttura:

```Swift
  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  
  // MARK: Public
  
  
  // MARK: Private
```

### Implementazione di protocolli
Implementare eventuali protocolli creando `extension` della classe per separare logicamente il codice per contesto.

👍
```Swift
class MyViewController: UIViewController {
  // codice di classe
}

// MARK: - UITableViewDataSource
extension MyViewController: UITableViewDataSource {
  // implementazione dei metodi di UITableViewDataSource
}

// MARK: - UIScrollViewDelegate
extension MyViewController: UIScrollViewDelegate {
  // implementazione dei metodi di UIScrollViewDelegate
}
```

👎
```Swift
class MyViewController: UIViewController, UITableViewDataSource, UIScrollViewDelegate {
  // tutti i metodi
}
```

### Codice inutilizzato
Sempre per migliorare la leggibilità, in generale, è meglio rimuovere:
* codice non più utilizzato o sostituito da altre parti di codice
* vecchio codice commentato
* metodi che chiamano semplicemente la `superclass`

👍
```Swift
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  return elements.count
}
```

👎
```Swift
// Questo metodo non aggiunge nessuna implementazione specifica quindi è meglio ometterlo
override func didReceiveMemoryWarning() {
  super.didReceiveMemoryWarning()
  // Dispose of any resources that can be recreated.
}

override func numberOfSections(in tableView: UITableView) -> Int {
  // #warning Incomplete implementation, return the number of sections
  return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  // #warning Incomplete implementation, return the number of rows
  return elements.count
}
```

## Indentazione
* Le parentesi graffe `{` `}` vanno sempre aperte sulla stessa riga e chiuse su un'altra riga.
> **CONSIGLIO:** Si può indentare automaticamente premendo `⌘+A` (seleziona tutto) e `Control+i` (indentazione automatica)

👍
```Swift
if user.isHappy {
  // Do something
} else {
  // Do something else
}
```

👎
```Swift
if user.isHappy
{
  // Do something
}
else {
  // Do something else
}
```

* I due punti `:` hanno sempre uno spazio a destra e zero a sinistra. Eccezioni: operatore ternario `? :`, dizionario vuoto `[:]` e `#selector` per metodi con paramteri senza nome `(_:)`.

👍
```Swift
class TestDatabase: Database {
  var data: [String: CGFloat] = ["A": 1.2, "B": 3.2]
}
```

👎
```Swift
class TestDatabase : Database {
  var data :[String:CGFloat] = ["A" : 1.2, "B":3.2]
}
```

## Design pattern

### MVC
Apple utilizza nel proprio SDK il design pattern **MVC (Model-View-Controller)**.

Tale pattern normalmente promette di separare in 3 livelli il codice:

* Il **Model** è dove risiedono i dati dell'app. Persistenza, oggetti che rappresentano i dati, parser e networking sono normalmente in questo livello.
* Il livello **View** è la UI dell'app. Le sue classi rappresentano un elemento visibile dall'utente e dovrebbero essere tipicamente riusabili come ad esempio un pulsante.
* Il **Controller** ha il compito di prendere i dati dal *Model* e mostrarli nelle *View* ed elaborare le azioni dell'utente.

I legami tra i 3 layer sono rappresentabili così:
![Original MVC](https://github.com/tiknil/swift-style-guide/blob/master/images/original_mvc.png)

Per come è strutturato *UIKit* la realtà è che Apple utilizza un MVC leggermente modificato:
![Original MVC](https://github.com/tiknil/swift-style-guide/blob/master/images/apple_mvc.png)

In pratica *View* e *Controller* risultano molto legati portando a scrivere la maggioranza del codice nei **UIVIewController**. In ambito iOS viene infatti spesso associata un'altra definizione all'acronimo MVC: **Massive-View-Controller**.

I problemi introdotti da questo pattern modificato sono:

1. Il codice è **difficilmente testabile**
2. **Scarsa riusabilità** delle *view*

Per risolvere tali problemi Tiknil ha deciso di utilizzare il pattern MVVM descritto di seguito.

### MVVM

Il design pattern **MVVM (Model-View-ViewModel)** applicato all'SDK di Apple risulta una naturale evoluzione di MVC:
![Original MVC](https://github.com/tiknil/swift-style-guide/blob/master/images/mvvm.png)

Il livello **View** comprende quindi sia **UIView** che **UIViewController**:

L'obiettivo del **ViewModel** è di essere una **rappresentazione astratta** della view a cui è associato. Ad esempio se la view deve mostrare nome e cognome dell'utente il viewmodel avrà due proprietà di tipo string che contengono queste informazioni.

Ciò introduce i seguenti vantaggi:

* È possibile **sostituire la view** associata al viewmodel senza problemi.
* È possibile separare dalla view eventuali trasformazioni dei dati presenti nel model. Esempio: formattazione di una data in base alla lingua. Questa operazione viene normalmente chiamata **Presentation logic**.
* È possibile eseguire **test funzionali** direttamente sul viewmodel.

Per un'analisi più dettagliata dell'evoluzione MVC => MVVM leggere [questo articolo](https://www.objc.io/issues/13-architecture/mvvm/) di **Ash Furrow**.

### Inversion of Control e Dependency Injection
L'*Inversion of Control* (**IoC**) è un *software design pattern* secondo il quale ogni componente dell'applicazione deve ricevere il **controllo** da un componente appartenente ad una **libreria riusabile**.<br>
L'obiettivo è quello di rendere ogni componente il più indipendente possibile dagli altri in modo che ognuno sia modificabile singolarmente con conseguente maggior riusabilità e manutenibilità.

La *Dependency Injection* (**DI**) è una forma di *IoC* dove l'implementazione del pattern avviene stabilendo le dipendenze tra un componente e l'altro tramite delle *interfacce* (chiamate **interface contracts**).<br>
A tali interfacce viene associata un'implementazione in fase di istanziazione del componente (nel *costruttore*) oppure in un secondo momento tramite *setter*.<br>
In ogni caso è generalmente presente un oggetto **container** che si occupa di creare le istanze di ogni *interfaccia*; la configurazione di tale *container* può così influenzare le dipendenze tra i vari componenti.<br>
L'utilizzo della *DI* è molto utile per la realizzazione di test automatici, infatti modificando il *container* è possibile *mockare* le dipendenze che non si desidera testare.

References:

* [Semplice video che chiarisce il concetto di DI](https://www.youtube.com/watch?v=IKD2-MAkXyQ)

### Flow coordinator
Il *flow coordinator* pattern si occupa della gestione della navigazione dell'applicazione e della creazione/distruzione delle varie schermate quando necessario.

I vantaggi dell'utilizzo di questo pattern sono:

* **Decoupling fra schermate:** ogni schermata (View + ViewModel) non ha riferimenti ad altre schermate, ma espone solo un'interfaccia con eventi di navigazione che saranno interpretati dal coordinator.
* **Facilità di cambio navigazione:** in caso sia necessario cambiare il sistema di navigazione basta apportare modifiche al coordinator senza toccare minimamente le schermate.
* **Riusabilità del codice:** dato che View e ViewModel non si occupano di navigazione è più facile riutilizzarli anche se l'ambito di navigazione è differente.
* **Più facile da testare:** l'assenza di navigazione in View e ViewModel semplifica la creazione di test automatici.

Fondamentamentalmente un *Coordinator* non è altro che un semplice oggetto che è responsabile di configurare View e ViewModel e gestirne la presentazione in un determinato flusso di navigazione.

È opportuno che sia presente un coordinator principale, generalmente chiamato *AppCoordinator*, che si occupa dell'avvio della navigazione tramite l'avvio di vari coordinator secondari che si occupano di singoli flussi di navigazione atomicizzabili per contesto.

Esempio:

![Flow Coordinator pattern schema](https://github.com/tiknil/swift-style-guide/blob/master/images/flow_coordinator_pattern_schema.png)

In questo esempio l'`AppCoordinator` è il coordinator principale e all'avvio dell'app deciderà quale coordinator figlio avviare:

* `OnBoardingCoordinator`: al primo avvio dell'app avvierà questo coordinator per mostrare il tutorial.
* `AuthCoordinator`: se non è stata cachata l'autenticazione in un precedente avvio verrà avviato questo coordinator per permettere all'utente di loggarsi o registrarsi.
* `MainCoordinator`: questo coordinator può essere avviato direttamente all'avvio se l'autenticazione è stata cachata da sessioni precedenti, oppure in seguito al completamento di un autenticazione nella sessione corrente. Esso ha la possibilità di avviare il coordinator figlio `ProfileCoordinator` per mostrare la schermata di profilo dell'utente.

È interessante notare come sia il `ProfileCoordinator`, sia l'`AuthCoordinator` abbiano la possibilità di avviare l'`OnBoardingCoordinator` per permettere all'utente di visualizzare il tutorial quando lo desidera.

Nella documentazione dell'[esempio pratico](#esempio-pratico) possiamo vedere come Tiknil implementa MVVM + Coordinator nei propri progetti.

## Struttura del progetto
Nelle seguenti sezioni definiamo le best practices di Tiknil per l'impostazione di un progetto iOS in Swift chiamato **AwesomeApp**.

### Repository e CocoaPods
La root del repository avrà la seguente struttura:

```
|-- .git                         # Working copy di git
|-- AwesomeApp                   # Codice sorgente dell'app
|-- AwesomeAppTests              # Unit test automatici
|-- AwesomeAppUITests            # Test automatici di UI
|-- Pods                         # Cartella contenente le librerie CocoaPods
|-- Podfile.lock                 # Gestione versioni dei pods. Gestito automaticamente da CocoaPods
|-- .gitignore                   # Specifica i file da escludere dal repo
|-- Podfile                      # Configurazione dei pod 
|-- Readme.md                    # Readme con modifiche di versione
|-- AwesomeApp.xcodeproj         # File di progetto. Non va utilizzato
|-- AwesomeApp.xcworkspace       # File del workspace contenente configurazione dei CocoaPods.
```

Prima del primo commit sul repository git aggiungere il file [.gitignore](https://github.com/tiknil/swift-style-guide/blob/master/resources/.gitignore).

### Cartelle di progetto
La cartella contenente il codice sorgente dell'app avrà la seguente struttura:

```
|-- Helpers           # Classi di generico aiuto per tutto l'app. Es: Colors.swift
|-- Models            # Tutti gli oggetti model
|-- Coordinators      # Tutti i coordinators per gestire il flusso di navigazione dell'app
|-- ViewModels        # Tutti i viewmodel eventualmente inseriti in sottocartelle di sezione
|-- Views             # Tutti i viewcontroller eventualmente inseriti in sottocartelle di sezione
    |-- Reusable      # Tutte le view riutilizzabili in altre view. Es: navigation bar custom
|-- UI                # Storyboards e xib.
    |-- Reusable      # Xib relativi alle view nella cartella Views/Reusable
|-- Services          # Oggetti che forniscono servizi come networking e persistenza
|-- Libraries         # Librerie create da Tiknil non importate come submodule
|-- Vendors           # Librerie di terzi non importate con CocoaPods o submodule
|-- Resources         # Assets, fonts, ecc
|-- Application       # Info.plist, AppDelegate.swift ed eventual bridging-header.h
```

Le cartelle al primo livello le creiamo fisicamente nel file system e le importiamo in modo che creino il gruppo logico nel progetto Xcode, mentre quelle al secondo livello possiamo anche lasciarle solo come gruppi logici.

## ReactiveX

Tiknil utilizza _[ReactiveX](https://github.com/ReactiveX/RxSwift)_ nei propri progetti sia per la manipolazione dei dati, sia per la visualizzazione di quest'ultimi nella UI.

**ReactiveX** non è altro che una generica definizione di API per la programmazione asincrona che estende l'[Observer pattern](https://it.wikipedia.org/wiki/Observer_pattern) per supportare sequenze di dati/eventi e fornendo operatori per manipolarle; tale definizione viene implementata in molti linguaggi diversi permettendoci quindi di utilizzare gli stessi concetti sia su iOS che Android.<br>
Nel caso di Swift tali API sono implementate nella libreria [RxSwift](https://github.com/ReactiveX/RxSwift), quindi faremo riferimento ad essa per esemplificare i concetti spiegati di seguito.

Con _sequenza/stream di dati_ si intende generalmente un flusso di uno o più dati ordinati in una sequenza temporale, come ad esempio:

* Click su un elemento dell'interfaccia grafica; in questo caso si tratta di stream di uno **stesso dato** nel tempo.
* Caratteri inseriti in input dall'utente; in questo caso si tratta di stream di **dati dello stesso tipo** (stringa) nel tempo.
* Chiamata di un'api con esito positivo o negativo; in questo caso si tratta di stream di **dati di tipo diverso** a seconda dell'esito (es: _positivo => json_, _negativo => errore_).
* Modifiche ad una proprietà di un oggetto; in questo caso si tratta di uno stream che rappresenta lo **storico dei valori** assunti dalla proprietà.

Come possiamo intuire da questi esempi è possibile creare stream di dati di qualsiasi tipo come _variabili, input utente, proprietà, cache, strutture dati_, etc.

L'operazione fondamentale fornita da _ReactiveX_ è infatti l'**osservazione** di uno stream per _reagire_ di conseguenza. Nella pratica, con _osservazione_, si intende l'esecuzione di una funzione ogni volta che compare un dato sullo stream (generalmente chiamato **Evento**).

**RxSwift** implementa i vari concetti reactive con le seguenti classi:

* `Event`: unità di base trasportata da uno _stream_; si tratta quindi del dato vero e proprio.<br>
_Esempio: in una trasmissione video l'event rappresenta un frame del video._
* `Observable`: flusso (_stream_) unidirezionale di eventi; come si può intuire dal nome, l'_observable_ può essere _osservato_ da altri oggetti.<br>
Un _observable_ può essere [**hot** o **cold**](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/HotAndColdObservables.md):
	* **Hot observable:** può iniziare ad emettere eventi appena creato e chiunque inizi ad osservarlo in un secondo momento riceverà eventi solo dal momento dell'osservazione in poi.<br>
_Esempio: in una trasmissione video l'hot observable rappresenta un canale tv: esso infatti è un flusso di event (frame) continuo e gli osservatori vedono il programma da quando si sintonizzano in poi, anche se esso è già iniziato in precedenza._
	* **Cold observable:** aspetta ad emettere eventi fino a quando qualcuno inizia ad osservarlo, garantendo all'osservatore di ricevere l'intera sequenza.<br>
_Esempio: in una trasmissione video il cold observable rappresenta un programma tv on demand (es: Netflix) che l'utente può avviare quando vuole generando appunto uno stream di event (frame)_
* `Observer` (o `Subscriber`): oggetto che si _sottoscrive_ ad un observable ricevendo così gli eventi emessi da esso.<br>
_Esempio: nel caso delle trasmissioni tv l'observer è il telespettatore (o più precisamente il televisore)._

Ogni framework reactive mette sempre a disposizione utili funzioni per **creare, combinare, filtrare e trasformare** gli stream agevolandone così la manipolazione. _ReactiveX_ chiama tali funzioni **operatori** e sono documentate [qui](http://reactivex.io/documentation/operators.html).

Per maggiori informazioni consultare la documentazione di [_RxSwift_](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md) e [ReactiveX](http://reactivex.io/intro.html).

## Esempio pratico
Al seguente link è disponibile il codice di un'applicazione di esempio che integra tutte le **best practice** definite in questo documento:

[GotEpisodes](https://github.com/tiknil/swift-style-guide/tree/master/examples/GotEpisodes)
