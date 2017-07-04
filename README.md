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
struct MyAwesomStruct { ... }
let constant = "http://www.tiknil.com"
var variable = 3
```

👎
```Swift
class myAwesomeClass { ... }
struct my_awesom_struct { ... }
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
Nelle classi utilizzare lo [snippet di codice] per la generazione dei `MARK` in modo da separare uniformemente il codice in tutte le classi secondo la seguente struttura:

```Swift
  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  
  // MARK: Private
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  
  // MARK: Custom accessors
  
  
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
* Indentare usando 2 spazi. Impostare Xcode nel modo seguente da `Preferences > Text Editing > Indentation`:
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
