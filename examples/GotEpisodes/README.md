# GotEpisodes
Questa applicazione visualizza la lista degli episodi della serie **Game of Thrones** in una semplice *TableView* con la relativa pagina di dettaglio.

L'obiettivo di questa applicazione è dimostrare l'utilizzo delle [best practice](https://github.com/tiknil/swift-style-guide) di Tiknil nella realizzazione di un'applicazione con particolare attenzione ai seguenti concetti:

* [Dependency Injection](#dependency-injection)
* [Inversion of Control Container](#inversion-of-control-container)
* [MVVM](#mvvm)
	* [View](#view)
	* [ViewModel](#viewmodel)
* [Binding](#binding)
* [Services](#services)
* [Coordinator](#coordinator)
* [JSON Mapping](#json-mapping)
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


## MVVM

In iOS il ruolo di _View_ è svolto dalle classi `UIViewController` e `UIView` (e rispettivi figli).<br>
L'obiettivo di tale ruolo è la realizzazione grafica di una schermata (o componente) **SENZA** nessuna logica di business perché essa sarà implementata nel _ViewModel_ associato.<br>
Si può pensare alla _View_ come a una semplice _skin_ grafica di ciò che viene rappresentato in maniera astratta dal _ViewModel_; ad esempio, se nel _ViewModel_ è presente una proprietà testo di tipo `String`, nella _View_ associata sarà presente una `UILabel` o una `UITextView` a seconda che il testo debba essere modificabile o meno.<br>
Anche la logica conseguente alle azioni compiute sulla grafica va implementate nel _ViewModel_; ad esempio se nella _View_ è presente un pulsante, il _ViewModel_ metterà a disposizione un handler da associare alla pressione del pulsante.

L'associazione tra _View_ e _ViewModel_ viene effettuata tramite [Binding](#binding) tra gli oggetti `UIKit` presenti nella _View_ e gli oggetti _RxSwift_ messi a disposizione dal _ViewModel_.

### View

Se la _View_ rappresenta una schermata allora sarà figlia di un `UIViewController`, altrimenti può essere semplicemente figlia di una `UIView`.<br>
Nel primo caso è consigliato creare per ogni progetto un `BaseViewController` che estenda `UIVIewController` da utilizzare come padre di qualsiasi _ViewController_ creeremo in app. Questo perché capita spesso che all'interno di un'applicazione siano presenti metodi comuni a qualsiasi schermata, quindi torna molto utile questa soluzione.

L'unico requisito di una _View_ è che abbia una dipendenza da un _ViewModel_, ma tramite un protocollo **ViewModelProtocol** per questioni di migliore testabilità.<br>
Tale dipendenza può essere passata tramite il costruttore o come proprietà a seconda che si utilizzi o meno uno storyboard.

Una volta iniettata la dipendenza di tipo _ViewModelProtocol_, l'unico onere della _View_ è effettuare i **binding** con le proprietà esposte da essa, oltre a fare eventuali ulteriori setting grafici.

### ViewModel

Un _ViewModel_ è composto da un protocollo (_ViewModelProtocol_) e dall'implementazione dello stesso (_ViewModel_).<br>
Sarà compito dell'_IoC Container_ istanziare il _ViewModel_ ogni volta che è richiesto un _ViewModelProtocol_ come dipendenza.

#### Protocol

Il protocollo conterrà diverse categorie di proprietà _RxSwift_:

* **Outputs**: tutte le proprietà che hanno il compito di **inviare** un'informazione alla _View_: _ViewModel_ => _View_.<br>
Es: `String` da mostrare in `UILabel`, `Bool` per gestire visibilità di `UIView`, ecc.
* **Inputs**: tuttle le proprietà che hanno il compito di **ricevere** un'informazione alla _View_: _View_ => _ViewModel_.<br>
Es: tap su un pulsante, cambio del valore di uno switch, elemento selezionato da una lista, ecc.
* **Bidirectional**: tutte le proprietà che **inviano e ricevono** informazioni dalla _View_: _View_ <=> _ViewModel_.<br>
Es: textfield con testo impostabile da viewmodel.

Gli _outputs_ saranno nella stragrande maggioranza dei **Driver**, un particolare _trait_ di _RxSwift/RxCocoa_ che consiste in un observable che invia eventi sempre sul main thread e che non può fallire.

Gli _inputs_ saranno invece sempre **AnyObserver** perché il flusso dell'informazione è in ricezione dalla _View_.

I _bidirectional_ saranno sempre dei **BehaviorRelay**, un particolare _trait_ di _RxSwift/RxCocoa_ che si comporta sia da _Observable_ che da _Observer_ fungendo da wrapper al concetto _ReactiveX_ di [BehaviorSubject](http://reactivex.io/documentation/subject.html) ma, allo stesso modo del driver, forzando l'osservazione sul main thread e impedendo la propagazione di errori nella sequenza.<br>
**Nota:** evitare di utilizzare le _Variable_ perché nonostante siano molto simili a _BehaviorRelay_ e in passato venissero usate al loro posto esse sono state deprecate in quando estranee ai concetti standard di _ReactiveX_.

Esempio:

```swift
protocol ViewModelProtocol {
  // Outputs
  var numberOfTapsText: Driver<String> { get }
  
  // Inputs
  var buttonTap: AnyObserver<Void> { get }
  
  // Bidirectional
  var textFieldText: BehaviorRelay<String?> { get }
}
```

#### Implementation

L'oggetto che implementa il protocollo avrà il compito di definire le **logiche** di mutazione degli eventi che transitano tra outputs e inputs, tipicamente recuperando informazioni dai **Model** accessibili tramite **Service** iniettati come dipendenze.

Il _ViewModel_ avrà un **costruttore** che riceve almeno il **Container** da cui risolvere le dipendenze necessarie ed eventualmente altri parametri utili per la visualizzazione della schermata (es: in una schermata di dettaglio utente ci sarà come parametro anche l'id (o direttamente il model) dell'utente da mostrare).

Gli _outputs_ sono **Driver** e possono essere creati ad hoc o mappati da altri _Observable_ (ad esempio dai _Service_) eventualmente utilizzando il metodo `asDriver(onErrorJustReturn:)`.

Gli _inputs_ sono **AnyObserver**, quindi si possono creare definendo localmente **PublishSubject** per poi esporne l'observer tramite il metodo `asObserver()`.<br>
Tale _PublishSubject_ può essere quindi osservato dal _ViewModel_ per effettuare l'handling delle azioni ricevute dalla _View_.

Esempio:

```swift
protocol CacheServiceProtocol {
  // Un BehaviorRelay è un wrapper di un BehaviorSubject con le stesse caratteristiche di un Driver,
  // ovvero sempre su main thread e senza possibilità di fallire
  var numberOfTaps: BehaviorRelay<Int> { get }
}

final class ViewModel: ViewModelProtocol {
  // Outputs
  let numberOfTapsText: Driver<String>
  
  // Inputs
  let buttonTap: AnyObserver<Void>
  
  private let disposeBag = DisposeBag()
  
  // Costruttore
  init(container: Container) {
    // In questo esempio istanzio un service di cache per recuperare il numero di tap salvati in memoria
    let cacheService = container.resolve(CacheServiceProtocol.self)!
    
    // Outputs
    // Recupero il driver numero di tap dal cacheService mappandolo da Int a String
    numberOfTapsText = cacheService.numberOfTaps
    	.asDriver()
    	.map { "Numero di tap: \($0)" }
    	
    // Inputs
    let buttonTapPs = PublishSubject<Void>()
    buttonTap = buttonTapPs.asObserver()
    
    // Osservo il PublishSubject per eseguire l'handling ad ogni ricezione di un evento di tap dalla view
    buttonTapPs.bind {
    	  cacheService.numberOfTaps.value = cacheService.numberOfTaps.value + 1
    	}
    	.disposed(by: disposeBag)
  }
}
```

## Binding

Con **binding** si intende il collegamento di una risorsa grafica con il dato o l'azione relativa presente nel _ViewModel_.

Può essere _unidirezionale_:

* _Dato => UI:_ ogni modifica del dato viene automaticamente visualizzata nel UI relativa.<br>
Es: `String => UILabel`
* _UI => Dato_: ogni modifica/azione al componente UI viene automaticamente propagato nel dato relativo.<br>
Es: `UIButton tap => ViewModel handler`

o _bidirezionale_:

* _UI <=> Dato_: ogni cambiamento viene propagato all'altro elemento. **Attenzione:** è facile che si creino dei cicli infiniti se non si prendono le dovute precauzioni.<br>
Es: `UITextView <=> String`

Il **binding** permette di creare delle _View_ completamente ignoranti della business logic che sta dietro a ciò che va visualizzato, con il semplice obiettivo di visualizzare ciò che viene rappresentato in maniera astratta dal _ViewModel_.<br>
In questo modo è possibile sostituire completamente l'aspetto grafico di una schermata mantenendo la business logic implementata nel _ViewModel_.

Per realizzare i binding utilizziamo [RxSwift/RxCocoa](https://github.com/ReactiveX/RxSwift).

### Outputs binding

Grazie a **RxSwift** possiamo creare un binding tra ogni componente grafico `UIKit` e una proprietà di tipo `Driver` definita nel _ViewModel_, utilizzando il metodo `drive`.

Come accennato nel capitolo [ViewModel](#viewmodel), un **Driver** è un wrapper di un _Observable_ che forza l'osservazione sul main thread filtrando eventuali errori.

#### ViewModel - Dichiarazione Driver

```Swift
// Dichiarazione di un Driver con un singolo evento
let nameText: Driver<String?> = Driver.just("Mario Rossi")

// Dichiarazione di un Driver partendo da un observable esistente (getUser -> Observable<User>,
// dove l'oggeto user contiene una proprietà name di tipo stringa
let nameText: Driver<String?> = apiService.getUser().map { $0.name }.asDriver(onErrorJustReturn: nil)

// Esposizione di un Driver a partire da un BehaviorRelay utilizzato per gestire l'evoluzione del dato
private let nameIsHiddenBr: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
let nameIsHidden: Driver<Bool> = nameIsHiddenBr.asDriver()
// È possibile inviare nuovi eventi al BehaviorRelay utilizzando la proprietà value
nameIsHiddenBr.value = true
```

#### View - Creazione binding

```Swift
// Testo di label bindato viewmodel.nameText
viewmodel.nameText
	.drive(nameLabel.rx.text)
	.disposed(by: disposeBag)
    
// La visualizzazione del nameLabel si basa sull'ultimo evento ricevuto sul Driver viewmodel.nameIsHidden
viewmodel.nameisHidden
	.drive(nameLabel.rx.isHidden)
	.disposed(by: disposeBag)
```

### Inputs binding

Utilizzando **RxSwift** possiamo creare nel _ViewModel_ degli `AnyObserver` a cui bindare dei `ControlEvents` forniti da `UIKit`.

#### ViewModel - Dichiarazione AnyObserver

```Swift
private let disposeBag = DisposeBag()

// PublishSubject per avere Observable e Observer
private let buttonTapPs = PublishSubject<Void>()

// Espongo l'observer alla View in modo che possa bindare un ControlEvent
let buttonTap: AnyObserver<Void> = buttonTapPs.asObserver

// Osservo (o bindo) l'handler da eseguire ogni volta che l'utente tappa sul pulsante
buttonTapPs.bind {
	  // Handler sul tap
	}
	.disposed(by: disposeBag)
```

#### View - Creazione binding

```Swift
// Quando il pulsante viene premuto viene eseguito l'handler definito nel viewmodel;
// è molto utile usare l'operatore throttle sui button in modo da evitare doppi tap accidentali
button.rx.tap
	.throttle(0.5, scheduler: MainScheduler.instance)
	.bind(to: viewmodel.buttonTap)
	.disposed(by: disposeBag)
```

### Bidirectional binding

Il binding bidirezionale non è direttamente supportato da `RxSwift` anche perché può essere formalmente realizzato combinando un input e un output, però nel caso più classico del `UITextField` per un form precompilato si può utilizzare l'operatore `<->` fornito dalla libreria [RxBiBinding](https://github.com/RxSwiftCommunity/RxBiBinding).

Per utilizzi più complessi del bidirectional binding far riferimento a [questo articolo](https://medium.com/@dannylazarow/rxswift-reverse-observable-aka-two-way-binding-5027cbfdc6f0).

<hr>

Per informazioni più approfondite consultare la documentazione di [RxSwift](https://github.com/ReactiveX/RxSwift) e/o di [ReactiveX](http://reactivex.io/documentation/observable.html).


## Services

Chiamiamo **Service** una classe dedicata all'esecuzione di _business logic_ legata a una stesso ambito iniettabile come dipendenza ove necessario, tramite corrispettivo **ServiceProtocol**.

Esempi dei più utilizzati:

* **ApiService:** dedicato alle chiamate network alle API del server.
* **CacheService:** dedicato alla storicizzazione di dati (database, portachiavi, file).
* **DataService:** dedicato all'utilizzo di dati temporanei disponibili solo in fase di esecuzione.
* **LocationService:** dedicato alla gestione del geoposizionamento dell'utente.
* **BluetoothService:** dedicato alla gestione della comunicazione bluetooth.
* **WebSocketService:** dedicato alla comunicazione via WebSocket.
* _ecc..._

## Coordinator
coming soon

## JSON Mapping
coming soon

## Testing
coming soon

# Improvements

Nella seguente lista riportiamo una serie di improvement che in futuro vorremmo applicare alle best practice descritte in questo documento:

* Cambiare il router in modo da permettere la navigazione _ViewModel_ => _ViewModel_ con gestione automatica della _View_ associata al _ViewModel_ target.