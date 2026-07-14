import '../model/sede.dart';
import '../model/categoria.dart';
import '../model/posicion.dart';
import '../model/entidad.dart';

abstract class CatalogRepository {
  Future<List<Entidad>> getEntidades();
  Future<void> createEntidad(Map<String, dynamic> data);
  Future<void> updateEntidad(String id, Map<String, dynamic> data);
  Future<void> deleteEntidad(String id);
  
  Future<List<Categoria>> getCategorias({String? entidadId});
  Future<void> createCategoria(Map<String, dynamic> data);
  Future<void> updateCategoria(String id, Map<String, dynamic> data);
  Future<void> deleteCategoria(String id);
  
  Future<List<Sede>> getSedes({String? entidadId});
  Future<void> createSede(Map<String, dynamic> data);
  Future<void> updateSede(String id, Map<String, dynamic> data);
  Future<void> deleteSede(String id);
  
  Future<List<Posicion>> getPosiciones();
}
