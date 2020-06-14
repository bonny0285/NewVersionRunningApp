import UIKit

//let my = [1 : 1,2 : 2,3 : 3,4 : 4,5 : 5]
//
//print(my)
//print(my)
//print(my)
//print(my)

//
//var prova: () -> ()
//
//
//var simpleClosure = {
//    return "Ciao a tutti"
//}
//
//
//simpleClosure()
//
//var closure : (String) -> () = { saluto in
//    print(saluto)
//}
//
//closure("ciao a tutti")
//
//
//var closureReturn : (Int,Int) -> (Int) = { num1 , num2 in
//    return num1 + num2
//}
//
//
//let somma = closureReturn(10,10)
//
//print(somma)
//
func prova2 (nome: [String], copletion:(String) -> (String)){
    var ris = ""
    for n in nome {
        if n == "Max" {
            ris = n
        }
    }
    copletion(ris)
}

let arr = ["Andrea", "Giovanni", "Federica", "Max"]

prova2(nome: arr) { (name) -> (String) in
    print(name)
    return name
}

