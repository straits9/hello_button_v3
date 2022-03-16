class Food {
  String? imgUrl;
  String? desc;
  String? name;
  String? waitTIme;
  num? score;
  String? cal;
  num? price;
  num? quantity;
  List<Map<String, String>>? ingredients;
  String? about;
  bool highLight;
  Food(
      {this.imgUrl,
      this.desc,
      this.name,
      this.waitTIme,
      this.score,
      this.cal,
      this.price,
      this.quantity,
      this.ingredients,
      this.about,
      this.highLight = false});
  static List<Food> generateRecommendFoods() {
    return [
      Food(
        imgUrl: 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/dish1.png',
        desc: 'No1. in sales',
        name: 'Soba Soup',
        waitTIme: '50min',
        score: 4.8,
        cal: '325 Kcal',
        price: 12,
        quantity: 1,
        ingredients: [
          {'Noodle': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre1.png'},
          {'Shrimp': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre2.png'},
          {'Egg': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre3.png'},
          {'Scallion': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre4.png'},
          {'Noodle': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre1.png'},
        ],
        about:
            'Soba Noodle Soup, or Toshikoshi Soba, symbolizes good luck in the new year and is traditionally eaten by the Japanese on the 31st of December.',
        highLight: true,
      ),
      Food(
        imgUrl: 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/dish2.png',
        desc: 'No1. in sales',
        name: 'Sei Ua Samun Phrai',
        waitTIme: '50min',
        score: 4.8,
        cal: '325 Kcal',
        price: 12,
        quantity: 1,
        ingredients: [
          {'Noodle': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre1.png'},
          {'Shrimp': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre2.png'},
          {'Egg': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre3.png'},
          {'Scallion': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre4.png'},
          {'Noodle': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre1.png'},
        ],
        about:
            ' A vibrant Thai sausage made with ground chicken, plus its spicy chile dip, from Chef Parnass Savang of Atlanta\'s Talat Market.',
        highLight: false,
      ),
      Food(
        imgUrl: 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/dish3.png',
        desc: 'No1. in sales',
        name: 'Ratatoullie Pasta',
        waitTIme: '50min',
        score: 4.8,
        cal: '325 Kcal',
        price: 12,
        quantity: 1,
        ingredients: [
          {'Noodle': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre1.png'},
          {'Shrimp': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre2.png'},
          {'Egg': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre3.png'},
          {'Scallion': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre4.png'},
          {'Noodle': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre1.png'},
        ],
        about:
            'A ratatouille is, by its very definition, a combination of vegetables fried and then simmered in a tomato sauce.',
        highLight: false,
      )
    ];
  }

  static List<Food>? generatePopularFood() {
    return [
      Food(
          imgUrl: 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/dish4.png',
          desc: 'Most Popular',
          name: 'Tomato Chicken',
          waitTIme: '50min',
          score: 4.8,
          cal: '325 Kcal',
          price: 12,
          quantity: 1,
          ingredients: [
            {'Noodle': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre1.png'},
            {'Shrimp': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre2.png'},
            {'Egg': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre3.png'},
            {'Scallion': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre4.png'},
            {'Noodle': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre1.png'},
          ],
          about:
              'Tomato Chicken Curry (Tamatar Murgh) is an Indian chicken curry cooked with lots of fresh tomatoes and mild spices. It goes very well with Indian bread or steamed rice.',
          highLight: false),
      Food(
          imgUrl: 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/dish1.png',
          desc: 'Most Popular',
          name: 'Soba Soup',
          waitTIme: '50min',
          score: 4.8,
          cal: '325 Kcal',
          price: 12,
          quantity: 1,
          ingredients: [
            {'Noodle': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre1.png'},
            {'Shrimp': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre2.png'},
            {'Egg': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre3.png'},
            {'Scallion': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre4.png'},
            {'Noodle': 'https://s3.ap-northeast-2.amazonaws.com/files.hellobell.net/hellobutton/v3/order/static/ingre1.png'},
          ],
          about:
              'Soba Noodle Soup, or Toshikoshi Soba, symbolizes good luck in the new year and is traditionally eaten by the Japanese on the 31st of December.',
          highLight: false),
    ];
  }
}
