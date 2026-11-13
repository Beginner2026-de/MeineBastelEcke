extends Node
@warning_ignore("unused_signal")
signal speicherstand_loeschen_gedrückt(full_path: String)
@warning_ignore("unused_signal")
signal speicherstand_geloescht()
@warning_ignore("unused_signal")
signal speicherstand_umbennen(path_zu_der_datei: String, neuer_name:String)
@warning_ignore("unused_signal")
signal speicherstand_fertig_umbenant()


# Wellen Graphf
@warning_ignore("unused_signal")
signal wellen_graphf_speicherstand_der_geladen_werden_soll(path:String)