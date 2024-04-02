class Filter {
  String filterName;
  List<double> matrix;

  Filter(this.filterName, this.matrix);

  String matrixToFFmpegColorChannelMixer() {
    if (matrix.length != 20) {
      return '';
    }

    String coefficients = '';
    for (int i = 0; i < 20; i += 4) {
      coefficients += 'rr=${matrix[i].toStringAsFixed(2)}:rg=${matrix[i + 1].toStringAsFixed(2)}:rb=${matrix[i + 2].toStringAsFixed(2)}:ra=${matrix[i + 3].toStringAsFixed(2)}:';
    }
    // Remove the trailing colon
    coefficients = coefficients.substring(0, coefficients.length - 1);

    return 'colorchannelmixer=$coefficients';
  }
}
