# GotEpisodes
Questa applicazione visualizza la lista degli episodi della serie **Game of Thrones** in una semplice *TableView* con la relativa pagina di dettaglio.

L'obiettivo di questa applicazione è dimostrare l'utilizzo delle [best practice](https://github.com/tiknil/swift-style-guide) di Tiknil nella realizzazione di un'applicazione con particolare attenzione ai seguenti concetti:

* [Dependency Injection](#dependency-injection)
* [Inversion of Control Container](#inversion-of-control-container)
* [MVVM](#mvvm)
* [Binding](#binding)
* [JSON Mapping](#json-mapping)
* [Services](#services)
* [Routing](#routing)
* [Testing](#testing)

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

Nell'[AppDelegate](https://github.com/tiknil/swift-style-guide/blob/master/examples/GotEpisodes/GotEpisodes/Application/AppDelegate.swift) è possibile vedere degli esempi di setup del **container** tramite **Swinject**.


## MVVM
coming soon

## Binding
coming soon

## JSON Mapping
coming soon

## Services
coming soon

## Routing
coming soon

## Testing
coming soon
