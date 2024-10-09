import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter para la interfaz de usuario.
import 'package:flutter_map/flutter_map.dart'; // Importa el paquete para utilizar mapas en Flutter.
import 'package:latlong2/latlong.dart'; // Importa la clase LatLng para manejar coordenadas geográficas.
import 'package:location/location.dart'; // Importa el paquete para obtener la ubicación actual del dispositivo.

class SimpleMapScreen extends StatefulWidget {
  const SimpleMapScreen({super.key}); // Constructor del widget. 

  @override
  _SimpleMapScreenState createState() => _SimpleMapScreenState(); // Crea el estado asociado a este widget.
}

class _SimpleMapScreenState extends State<SimpleMapScreen> {
  LatLng? _currentLocation; // Variable para almacenar la ubicación actual del usuario.
  Location _location = Location(); // Instancia para acceder a la ubicación del dispositivo.
  String _selectedOption = 'Parques'; // Opción seleccionada por defecto en el Dropdown.

  @override
  void initState() {
    super.initState(); // Llama al método initState de la clase padre.
    _getLocation(); // Obtiene la ubicación actual cuando se inicializa el widget.
  }

  // Método para obtener la ubicación actual del dispositivo.
  Future<void> _getLocation() async {
    LocationData _locationData = await _location.getLocation(); // Obtiene los datos de ubicación.
    setState(() {
      _currentLocation = LatLng( // Actualiza la ubicación actual con las coordenadas obtenidas.
        _locationData.latitude!, // Latitud de la ubicación.
        _locationData.longitude!, // Longitud de la ubicación.
      );
    });
  }

  // Método que simula la búsqueda basada en la opción seleccionada.
  void _onSearch() {
    // Lógica de búsqueda según la opción seleccionada
    print('Buscando $_selectedOption cerca de la ubicación actual'); // Imprime en consola la opción seleccionada.
    // Aquí puedes añadir la lógica para mostrar marcadores según la opción seleccionada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Simple'), // Título de la barra de aplicación.
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0), // Espaciado alrededor del widget.
            child: Row(
              children: [
                // Dropdown para seleccionar opciones
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedOption, // Valor actual del Dropdown.
                    items: const [
                      DropdownMenuItem(
                        value: 'Parques', // Opción del Dropdown.
                        child: Text('Parques'), // Texto mostrado en el Dropdown.
                      ),
                      DropdownMenuItem(
                        value: 'Paradas',
                        child: Text('Paradas'),
                      ),
                      DropdownMenuItem(
                        value: 'Hoteles',
                        child: Text('Hoteles'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption = newValue!; // Actualiza la opción seleccionada.
                      });
                    },
                  ),
                ),
                // Botón de búsqueda
                ElevatedButton(
                  onPressed: _onSearch, // Acción a ejecutar al presionar el botón.
                  child: const Text('Buscar'), // Texto del botón.
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentLocation == null // Verifica si la ubicación actual es nula.
                ? const Center(
                    child: CircularProgressIndicator(), // Muestra un indicador de carga mientras se obtiene la ubicación.
                  )
                : FlutterMap(
                    options: MapOptions(
                      center: _currentLocation, // Posición inicial del mapa en la ubicación actual.
                      zoom: 15.0, // Nivel de zoom del mapa.
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: // Plantilla de URL para obtener los mosaicos del mapa.
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'], // Subdominios para la carga de mosaicos.
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 80.0, // Ancho del marcador.
                            height: 80.0, // Altura del marcador.
                            point: _currentLocation!, // Ubicación del marcador (la ubicación actual).
                            builder: (ctx) => const Icon(
                              Icons.location_on, // Icono que se mostrará en la ubicación actual.
                              size: 40.0, // Tamaño del icono.
                              color: Colors.red, // Color del icono.
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
