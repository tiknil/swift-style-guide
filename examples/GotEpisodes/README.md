# GotEpisodes
Questa applicazione visualizza la lista degli episodi della serie **Game of Thrones** in una semplice *TableView* con la relativa pagina di dettaglio.

L'obiettivo di questa applicazione è dimostrare l'utilizzo delle [best practice](https://github.com/tiknil/swift-style-guide) di Tiknil nella realizzazione di un'applicazione con particolare attenzione ai seguenti concetti:

* [Dependency Injection](#dependency-injection)
* [Inversion of Control Container](#inversion-of-control-container)
* [MVVM](#mvvm--libreria-tkmvvm)
* [Binding](#binding)
* [Services](#services)
* [Routing](#routing)
* [JSON Mapping](#json-mapping)
* [Testing](#testing)
* [Improvements](#improvements)

## Dependency Injection
Esistono 3 tipi di **Dependency Injection**:

* **Constructor** injection: le dipendenze vengono fornite attraverso un costruttore

```Swift
// Dipendenza
public let dependency: Dependency

// Costruttore
init(dependency: Dependency) {
  self.dependency = dependency
  // Dipendenza iniettata
}
```
* **Setter** injection: le dipendenze vengono fornite tramite un metodo *setter*

```Swift
// Proprietà con setter 
public var dependency: Dependency? {
  didSet {
    if let d = dependency {
      // Dipendenza iniettata
    }
  }
}
```
* **Interface** injection: la dipendenza offre un'interfaccia con un *setter* obbligatorio e ogni client implementa tale interfaccia per accettare la dipendenza

```Swift
// Interfaccia della dipendenza
protocol DependencyProtocol {
  func setDependency(dependency: Dependency)
}

// Classe client
class Client: DependencyProtocol {
  private var dependency: Dependency?
  
  public func setDependency(dependency: Dependency) {
    self.dependency = dependency
  }
}
```

Quando possibile prediligiamo la **Construction injection**, altrimenti utilizziamo la **Setter injection**.

È **SEMPRE** consigliato creare **dipendenze da interfacce** piuttosto che **dipendenze da classi** perché in fase di [testing](#testing) è possibile sostituire la dipendenza con uno *Stub/Mock*.

👍
```Swift
// Interfaccia della dipendenza
protocol DependencyProtocol {
  func awesomeMethod()
}

// Implementazione della dipendenza
class Dependency: DependencyProtocol {
  public func awesomeMethod() {
    print("Awesome method")
  }
}

// Classe client con dipendenza da interfaccia
class Client {
  public let dependency: DependencyProtocol
	
  init(dependency: DependencyProtocol) {
    self.dependency = dependency
  }
}

// Classe STUB utilizzata nei test
class StubDependency: DependencyProtocol {
  public func awesomeMethod() {
    print("STUBBED awesome method")
  }
} 
```

👎
```Swift
// Classe della dipendenza
class Dependency {
  public func awesomeMethod() {
    print("Awesome method")
  }
}

// Classe client con dipendenza da classe
class Client {
  public let dependency: Dependency
  
  init(dependency: Dependency) {
    self.dependency = dependency
  }
}

// Nei test è scomodo sostituire la dipendenza
```

## Inversion of Control Container
Per iniettare le dipendenze è molto comodo utilizzare un **IoC Container**. La libreria [Swinject](https://github.com/Swinject/Swinject) ci mette a disposizione proprio questa funzionalità.

Un **IoC Container** è un oggetto *singleton* che offre le seguenti funzionalità:
* **Registrazione** di classi o interfacce: l'operazione di registrazione (*register*) definisce un modo univoco per creare un'implementazione della classe/interfaccia in oggetto.
* **Risoluzione** di classi o interfacce: l'operazione di risoluzione (*resolve*) ritorna un'istanza della classe/interfaccia in oggetto.

Queste semplici operazioni permettono di fornire un metodo unico per la creazione di istanze di classi/interfacce. Se tali istanze sono utilizzate come dipendenze è sufficiente cambiare la *registrazione* di tali dipendenze per modificare la dipendenza nell'intera applicazione.

### Risoluzione

#### Semplice

```Swift
// Risoluzione di un oggetto che implementa il protocollo MyAwesomeProtocol.
// La classe dell'oggetto dipende da come è stato registrato nel container (vedi paragrafo successivo).
let objectFromProtocol = container.resolve(MyAwesomeProtocol.self)

// Risoluzione di un oggetto della classe di tipo MyAwesomeClass.
let objectFromClass = container.resolve(MyAwesomeClass.self)
```

#### Parametrizzata

Se una classe/protocollo è stata registrata con 1 o più parametri la risoluzione può essere fatta nel modo seguente:

```Swift
// 1 parametro
let objectWithOneParam = container.resolve(MyAwesomeProtocol.self, argument: param1)

// 2 parametri
let objectWithTwoParams = container.resolve(MyAwesomeClass.self, arguments: param1, param2)
```

### Registrazione

#### Contratta

```Swift
// Registrazione della classe MyAwesomeClass come implementazione del protocollo MyAwesomeProtocol.
// In fase di risoluzione del protocollo MyAwesomeProtocol verrà quindi istanziata la class MyAwesomeClass;
// nei test si può effettuare un'override in modo che in fase di risoluzione venga istanziato uno stub.
container.register(MyAwesomeProtocol.self) { _ in
  MyAwesomeClass()
}
```

#### Estesa

```Swift
// Il parametro r è un riferimento al container (resolver) e permette quindi di risolvere altri oggetti.
// In questo caso viene utilizzato per effettuare una dependency injection tramite setter.
container.register(MyAwesomeProtocol.self) { r in
  let myAwesomeObject = MyAwesomeClass()
  myAwesomeObject.dependency = r.resolve(DependencyProtocol.self)
  return myAwesomeObject
}
```

#### Parametrizzata

```Swift
// Param può essere di qualsiasi tipo e la risoluzione funzionerà solo se viene
// passato esattamente quel tipo, altrimenti Swinject lancia un'eccezione.
container.register(MyAwesomeProtocol.self) { (r: Resolver, param: DependencyProtocol) in
  MyAwesomeClass(dependency: param) // Dependency injection tramite costruttore
}
```

#### Scope

Swinject permette di configurare lo _scope_ dell'istanza definita durante la registrazione.<br>
I diversi _scope_ sono documentati [qui](https://github.com/Swinject/Swinject/blob/master/Documentation/ObjectScopes.md), ma per quanto ci riguarda ci basta sapere che di default l'oggetto viene reistanziato ad ogni chiamata del _resolve_, mentre se vogliamo avere un oggetto **Singleton** possiamo assegnargli lo _scope_ `container`.

```Swift
// Ad ogni chiamata del resolve viene istanziato un nuovo oggetto MyNormalClass
container.register(MyNormalClass.self) { _ in
  MyNormalClass()
}

// Alla prima chiamata del resolve viene istanziato un nuovo oggetto MySingletonClass,
// mentre in seguito verrà restituito sempre un riferimento al primo oggetto
container.register(MySingletonClass.self) { _ in
  MySingletonClass()
}.inObjectScope(.container)
```


Nell'[AppDelegate](https://github.com/tiknil/swift-style-guide/blob/master/examples/GotEpisodes/GotEpisodes/Application/AppDelegate.swift) è possibile vedere degli esempi di setup del **container** tramite **Swinject**.


## MVVM - Libreria TkMvvm

La libreria Tiknil [TkMvvm](https://github.com/tiknil/swift-style-guide/blob/master/examples/GotEpisodes/GotEpisodes/Libraries/TkMvvm) predispone protocolli e classi base di **View** e **ViewModel** per la realizzazione del pattern **MVVM** con l'aggiunta di un [Router](#routing) per la gestione della navigazione.

In iOS il ruolo di _View_ è svolto dalle classi `UIViewController` e `UIView` (e rispettivi figli).<br>
L'obiettivo di tale ruolo è la realizzazione grafica di una schermata (o componente) **SENZA** nessuna logica di business perché essa sarà implementata nel _ViewModel_ associato.<br>
Si può pensare alla _View_ come a una semplice _skin_ grafica di ciò che viene rappresentato in maniera astratta dal _ViewModel_; ad esempio, se nel _ViewModel_ è presente una proprietà testo di tipo `String`, nella _View_ associata sarà presente una `UILabel` o una `UITextView` a seconda che il testo debba essere modificabile o meno.<br>
Anche gli handler delle azioni compiute sulla grafica vanno implementati nel _ViewModel_; ad esempio se nella _View_ è presente un pulsante, nel _ViewModel_ sarà presente un handler (chiamata **Action**) che va associato all'evento di pressione del pulsante.

L'associazione tra _proprietà_ e _action_ tra _View_ e _ViewModel_ viene effettuata tramite [Binding](#binding).

### View

Ogni _View_ deve implementare il protocollo `TkMvvmViewProtocol` in modo che:

* sia disponibile la proprietà `viewModel` contenente il riferimento al proprio _ViewModel_.
* venga implementato il metodo `setupBindings()` entro il quale vengono creati tutti i bindings tra _View_ e _ViewModel__

La libreria mette già a disposizione l'implementazione del protocollo per le classi `UIViewController` e `UITableViewController` associando un _ViewModel_ di tipo `TkMvvmViewModel` descritto nel capitolo successivo.<br>
Queste classi offrono le seguenti utilità:

* Invocazione automatica del metodo `setupBindings()` in seguito all'injection del _ViewModel_ come dipendenza.
* "Inoltro" automatico dei metodi di _lifecycle_ del _ViewController_ ai corrispettivi metodi definiti nel `TkMvvmViewModel`: `viewDidLoad`, `viewWillAppear`, `viewDidAppear`, `viewWillDisappear` e `viewDidDisappear`; ciò permette al _ViewModel_ di avere padronanza del _lifecycle_ del _ViewController_, pur non avendo riferimenti ad esso.
* Metodo rapido per istanziare il _ViewController_ da uno storyboard: `instantiateFrom(storyboardWithName:)`.

### ViewModel

Normalmente l'unico requisito di un _ViewModel_ è che sia un semplice oggetto _Swift_ che abbia proprietà di tipo `MutableProperty` e handler di tipo `Action` della libreria [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift) in modo che si riescano ad effettuare i binding con la rispettiva _View_.<br>
Nel caso quest'ultima sia figlia delle classi `TkMvvmViewController` o `TkMvvmTableViewController` allora è necessario che sia figlio della classe `TkMvvmViewModel` con il vantaggio di permettere al _ViewModel_ di avere padronanza del _lifecycle_ del _ViewController_ tramite i metodi: `viewDidLoad`, `viewWillAppear`, `viewDidAppear`, `viewWillDisappear` e `viewDidDisappear`.

### Best practice per l'utilizzo di TkMvvm

1. Per ogni schermata dell'app creare la _View_ utilizzando una sottoclasse di `TkMvvmViewController` (o `TkMvvmTableViewController`) e il rispettivo _ViewModel_ utilizzando una sottoclasse di `TkMvvmViewModel`.
2. Inserire tutti i binding tra _View_ <=> _ViewModel_ nel metodo `setupBindings()`.
3. Istanziare le `Action` del _ViewModel_ nel metodo `viewDidLoad()` del `TkMvvmViewModel`.

## Binding
coming soon

## Services
coming soon

## Routing
coming soon

## JSON Mapping
coming soon

## Testing
coming soon

## Improvements

Nella seguente lista riportiamo una serie di improvement che in futuro vorremmo applicare alle best practice descritte in questo documento:

* Cambiare il router in modo da permettere la navigazione _ViewModel_ => _ViewModel_ con gestione automatica della _View_ associata al _ViewModel_ target.