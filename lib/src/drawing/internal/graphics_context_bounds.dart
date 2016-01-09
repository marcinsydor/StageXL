part of stagexl.drawing.internal;

class GraphicsContextBounds extends GraphicsContextBase {

  double _minX = 0.0 + double.MAX_FINITE;
  double _minY = 0.0 + double.MAX_FINITE;
  double _maxX = 0.0 - double.MAX_FINITE;
  double _maxY = 0.0 - double.MAX_FINITE;

  //---------------------------------------------------------------------------

  double get minX => _minX;
  double get minY => _minY;
  double get maxX => _maxX;
  double get maxY => _maxY;

  Rectangle<num> get bounds {
    if (minX < maxX && minY < maxY) {
      return new Rectangle<double>(minX, minY, maxX - minX, maxY - minY);
    } else {
      return new Rectangle<double>(0.0, 0.0, 0.0, 0.0);
    }
  }

  //---------------------------------------------------------------------------

  @override
  void fillColor(int color) {
    GraphicsMesh mesh = _path;
    _updateBoundsForMesh(mesh);
  }

  @override
  void strokeColor(int color, double width, JointStyle jointStyle, CapsStyle capsStyle) {
    GraphicsMesh mesh = new GraphicsStroke(_path, width, jointStyle, capsStyle);
    _updateBoundsForMesh(mesh);
  }

  @override
  void meshColor(GraphicsCommandMeshColor command) {
    GraphicsMesh mesh = command.mesh;
    _updateBoundsForMesh(mesh);
  }

  //---------------------------------------------------------------------------

  void _updateBoundsForMesh(GraphicsMesh mesh) {
    for(var meshSegment in mesh.segments) {
      _minX = _minX > meshSegment.minX ? meshSegment.minX : _minX;
      _minY = _minY > meshSegment.minY ? meshSegment.minY : _minY;
      _maxX = _maxX < meshSegment.maxX ? meshSegment.maxX : _maxX;
      _maxY = _maxY < meshSegment.maxY ? meshSegment.maxY : _maxY;
    }
  }

}
