import Foundation

// Funzione per spostare il file nel Cestino
func moveToTrash(_ path: String) throws {
    let fileURL = URL(fileURLWithPath: path)
    let fileManager = FileManager.default

    // Verifica se il file o la directory esiste
    guard fileManager.fileExists(atPath: fileURL.path) else {
        throw NSError(domain: "FileNotFound", code: 1, userInfo: [NSLocalizedDescriptionKey: "File or directory not found: \(path)"])
    }

    // Sposta il file nel Cestino
    try fileManager.trashItem(at: fileURL, resultingItemURL: nil)
    print("File spostato nel Cestino: \(path)")
}

// Funzione per processare gli argomenti simile al comando rm
func processArguments() {
    let arguments = CommandLine.arguments

    // Ignora il primo argomento che è il nome del programma
    guard arguments.count > 1 else {
        print("Utilizzo: rm_swift [file...]")
        return
    }

    var encounteredFile = false  // Per gestire la logica richiesta

    for argument in arguments.dropFirst() {
        // Se abbiamo già incontrato un file, non ignorare più nulla
        if encounteredFile || !argument.hasPrefix("-") {
            encounteredFile = true
            do {
                try moveToTrash(argument)
            } catch {
                print("Errore: \(error.localizedDescription)")
            }
        } else {
            // Ignora parametri che iniziano con - prima del primo file
            continue
        }
    }
}

// Esegui la funzione di elaborazione degli argomenti
processArguments()