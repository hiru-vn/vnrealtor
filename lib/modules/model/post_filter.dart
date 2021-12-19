class PostFilter {
  double minPrice = 0;
  double maxPrice = 1000000000000;
  double minArea = 0;
  double maxArea = 10000;
  List<String>? categoryList = [];
  List<String>? action = [];

  PostFilter(
      {this.minPrice = 0,
      this.maxPrice = 1000000000000,
      this.minArea = 0,
      this.maxArea = 10000,
      this.categoryList,
      this.action}) {
    if (categoryList == null) {
      categoryList = [];
    }
    if (action == null) {
      action = [];
    }
  }
}
