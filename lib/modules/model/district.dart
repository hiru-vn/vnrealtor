final listDistrict = _rawData.map((e) => District.fromJson(e)).toList();

class District {
  int? stt;
  int? maquanhuyen;
  String? tenquanhuyen;
  String? caphanhchinh;
  List<Ward?>? wards;

  District(
      {this.stt,
      this.maquanhuyen,
      this.tenquanhuyen,
      this.caphanhchinh,
      this.wards});

  District.fromJson(Map<String, dynamic> json) {
    stt = json['stt'];
    maquanhuyen = json['maquanhuyen'];
    tenquanhuyen = json['tenquanhuyen'];
    caphanhchinh = json['caphanhchinh'];
    if (json['wards'] != null) {
      wards = (json['wards'] as List).map((e) => Ward.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stt'] = this.stt;
    data['maquanhuyen'] = this.maquanhuyen;
    data['tenquanhuyen'] = this.tenquanhuyen;
    data['caphanhchinh'] = this.caphanhchinh;
    return data;
  }
}

class Ward {
  int? stt;
  String? maphuongxa;
  String? tenphuongxa;
  String? caphanhchinh;
  int? maquanhuyen;

  Ward(
      {this.stt,
      this.maphuongxa,
      this.tenphuongxa,
      this.caphanhchinh,
      this.maquanhuyen});

  Ward.fromJson(Map<String, dynamic> json) {
    stt = json['stt'];
    maphuongxa = json['maphuongxa'];
    tenphuongxa = json['tenphuongxa'];
    caphanhchinh = json['caphanhchinh'];
    maquanhuyen = json['maquanhuyen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stt'] = this.stt;
    data['maphuongxa'] = this.maphuongxa;
    data['tenphuongxa'] = this.tenphuongxa;
    data['caphanhchinh'] = this.caphanhchinh;
    data['maquanhuyen'] = this.maquanhuyen;
    return data;
  }
}

final _rawData = [
  {
    "stt": 1,
    "maquanhuyen": 760,
    "tenquanhuyen": "Quận 1",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "26740",
        "tenphuongxa": "Phường Bến Nghé",
        "caphanhchinh": "Phường",
        "maquanhuyen": 760
      },
      {
        "stt": 2,
        "maphuongxa": "26743",
        "tenphuongxa": "Phường Bến Thành",
        "caphanhchinh": "Phường",
        "maquanhuyen": 760
      },
      {
        "stt": 3,
        "maphuongxa": "26761",
        "tenphuongxa": "Phường Cầu Kho",
        "caphanhchinh": "Phường",
        "maquanhuyen": 760
      },
      {
        "stt": 4,
        "maphuongxa": "26752",
        "tenphuongxa": "Phường Cầu Ông Lãnh",
        "caphanhchinh": "Phường",
        "maquanhuyen": 760
      },
      {
        "stt": 5,
        "maphuongxa": "26755",
        "tenphuongxa": "Phường Cô Giang",
        "caphanhchinh": "Phường",
        "maquanhuyen": 760
      },
      {
        "stt": 6,
        "maphuongxa": "26737",
        "tenphuongxa": "Phường Đa Kao",
        "caphanhchinh": "Phường",
        "maquanhuyen": 760
      },
      {
        "stt": 7,
        "maphuongxa": "26758",
        "tenphuongxa": "Phường Nguyễn Cư Trinh",
        "caphanhchinh": "Phường",
        "maquanhuyen": 760
      },
      {
        "stt": 8,
        "maphuongxa": "26746",
        "tenphuongxa": "Phường Nguyễn Thái Bình",
        "caphanhchinh": "Phường",
        "maquanhuyen": 760
      },
      {
        "stt": 9,
        "maphuongxa": "26749",
        "tenphuongxa": "Phường Phạm Ngũ Lão",
        "caphanhchinh": "Phường",
        "maquanhuyen": 760
      },
      {
        "stt": 10,
        "maphuongxa": "26734",
        "tenphuongxa": "Phường Tân Định",
        "caphanhchinh": "Phường",
        "maquanhuyen": 760
      }
    ]
  },
  {
    "stt": 2,
    "maquanhuyen": 769,
    "tenquanhuyen": "Quận 2",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27106",
        "tenphuongxa": "Phường An Khánh",
        "caphanhchinh": "Phường",
        "maquanhuyen": 769
      },
      {
        "stt": 3,
        "maphuongxa": "27115",
        "tenphuongxa": "Phường An Lợi Đông",
        "caphanhchinh": "Phường",
        "maquanhuyen": 769
      },
      {
        "stt": 4,
        "maphuongxa": "27091",
        "tenphuongxa": "Phường An Phú",
        "caphanhchinh": "Phường",
        "maquanhuyen": 769
      },
      {
        "stt": 5,
        "maphuongxa": "27094",
        "tenphuongxa": "Phường Bình An",
        "caphanhchinh": "Phường",
        "maquanhuyen": 769
      },
      {
        "stt": 6,
        "maphuongxa": "27103",
        "tenphuongxa": "Phường Bình Khánh",
        "caphanhchinh": "Phường",
        "maquanhuyen": 769
      },
      {
        "stt": 10,
        "maphuongxa": "27097",
        "tenphuongxa": "Phường Bình Trưng Đông",
        "caphanhchinh": "Phường",
        "maquanhuyen": 769
      },
      {
        "stt": 11,
        "maphuongxa": "27100",
        "tenphuongxa": "Phường Bình Trưng Tây",
        "caphanhchinh": "Phường",
        "maquanhuyen": 769
      },
      {
        "stt": 12,
        "maphuongxa": "27109",
        "tenphuongxa": "Phường Cát Lái",
        "caphanhchinh": "Phường",
        "maquanhuyen": 769
      },
      {
        "stt": 13,
        "maphuongxa": "27112",
        "tenphuongxa": "Phường Thạnh Mỹ Lợi",
        "caphanhchinh": "Phường",
        "maquanhuyen": 769
      },
      {
        "stt": 14,
        "maphuongxa": "27088",
        "tenphuongxa": "Phường Thảo Điền",
        "caphanhchinh": "Phường",
        "maquanhuyen": 769
      },
      {
        "stt": 15,
        "maphuongxa": "27118",
        "tenphuongxa": "Phường Thủ Thiêm",
        "caphanhchinh": "Phường",
        "maquanhuyen": 769
      }
    ]
  },
  {
    "stt": 3,
    "maquanhuyen": 770,
    "tenquanhuyen": "Quận 3",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27160",
        "tenphuongxa": "Phường 1",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      },
      {
        "stt": 2,
        "maphuongxa": "27157",
        "tenphuongxa": "Phường 2",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      },
      {
        "stt": 3,
        "maphuongxa": "27154",
        "tenphuongxa": "Phường 3",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      },
      {
        "stt": 4,
        "maphuongxa": "27148",
        "tenphuongxa": "Phường 4",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      },
      {
        "stt": 5,
        "maphuongxa": "27151",
        "tenphuongxa": "Phường 5",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      },
      {
        "stt": 6,
        "maphuongxa": "27139",
        "tenphuongxa": "Phường 6",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      },
      {
        "stt": 7,
        "maphuongxa": "27124",
        "tenphuongxa": "Phường 7",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      },
      {
        "stt": 8,
        "maphuongxa": "27121",
        "tenphuongxa": "Phường 8",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      },
      {
        "stt": 9,
        "maphuongxa": "27142",
        "tenphuongxa": "Phường 9",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      },
      {
        "stt": 10,
        "maphuongxa": "27145",
        "tenphuongxa": "Phường 10",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      },
      {
        "stt": 11,
        "maphuongxa": "27133",
        "tenphuongxa": "Phường 11",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      },
      {
        "stt": 12,
        "maphuongxa": "27130",
        "tenphuongxa": "Phường 12",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      },
      {
        "stt": 13,
        "maphuongxa": "27136",
        "tenphuongxa": "Phường 13",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      },
      {
        "stt": 14,
        "maphuongxa": "27127",
        "tenphuongxa": "Phường 14",
        "caphanhchinh": "Phường",
        "maquanhuyen": 770
      }
    ]
  },
  {
    "stt": 4,
    "maquanhuyen": 773,
    "tenquanhuyen": "Quận 4",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27298",
        "tenphuongxa": "Phường 1",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 2,
        "maphuongxa": "27292",
        "tenphuongxa": "Phường 2",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 3,
        "maphuongxa": "27286",
        "tenphuongxa": "Phường 3",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 4,
        "maphuongxa": "27283",
        "tenphuongxa": "Phường 4",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 5,
        "maphuongxa": "27274",
        "tenphuongxa": "Phường 5",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 6,
        "maphuongxa": "27265",
        "tenphuongxa": "Phường 6",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 7,
        "maphuongxa": "27268",
        "tenphuongxa": "Phường 8",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 8,
        "maphuongxa": "27262",
        "tenphuongxa": "Phường 9",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 9,
        "maphuongxa": "27271",
        "tenphuongxa": "Phường 10",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 10,
        "maphuongxa": "27256",
        "tenphuongxa": "Phường 12",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 11,
        "maphuongxa": "27259",
        "tenphuongxa": "Phường 13",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 12,
        "maphuongxa": "27280",
        "tenphuongxa": "Phường 14",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 13,
        "maphuongxa": "27295",
        "tenphuongxa": "Phường 15",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 14,
        "maphuongxa": "27289",
        "tenphuongxa": "Phường 16",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      },
      {
        "stt": 15,
        "maphuongxa": "27277",
        "tenphuongxa": "Phường 18",
        "caphanhchinh": "Phường",
        "maquanhuyen": 773
      }
    ]
  },
  {
    "stt": 5,
    "maquanhuyen": 774,
    "tenquanhuyen": "Quận 5",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27325",
        "tenphuongxa": "Phường 1",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 2,
        "maphuongxa": "27313",
        "tenphuongxa": "Phường 2",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 3,
        "maphuongxa": "27307",
        "tenphuongxa": "Phường 3",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 4,
        "maphuongxa": "27301",
        "tenphuongxa": "Phường 4",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 5,
        "maphuongxa": "27334",
        "tenphuongxa": "Phường 5",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 6,
        "maphuongxa": "27337",
        "tenphuongxa": "Phường 6",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 7,
        "maphuongxa": "27322",
        "tenphuongxa": "Phường 7",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 8,
        "maphuongxa": "27316",
        "tenphuongxa": "Phường 8",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 9,
        "maphuongxa": "27304",
        "tenphuongxa": "Phường 9",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 10,
        "maphuongxa": "27340",
        "tenphuongxa": "Phường 10",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 11,
        "maphuongxa": "27328",
        "tenphuongxa": "Phường 11",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 12,
        "maphuongxa": "27310",
        "tenphuongxa": "Phường 12",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 13,
        "maphuongxa": "27343",
        "tenphuongxa": "Phường 13",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 14,
        "maphuongxa": "27331",
        "tenphuongxa": "Phường 14",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      },
      {
        "stt": 15,
        "maphuongxa": "27319",
        "tenphuongxa": "Phường 15",
        "caphanhchinh": "Phường",
        "maquanhuyen": 774
      }
    ]
  },
  {
    "stt": 6,
    "maquanhuyen": 775,
    "tenquanhuyen": "Quận 6",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27370",
        "tenphuongxa": "Phường 1",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      },
      {
        "stt": 2,
        "maphuongxa": "27367",
        "tenphuongxa": "Phường 2",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      },
      {
        "stt": 3,
        "maphuongxa": "27379",
        "tenphuongxa": "Phường 3",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      },
      {
        "stt": 4,
        "maphuongxa": "27373",
        "tenphuongxa": "Phường 4",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      },
      {
        "stt": 5,
        "maphuongxa": "27361",
        "tenphuongxa": "Phường 5",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      },
      {
        "stt": 6,
        "maphuongxa": "27355",
        "tenphuongxa": "Phường 6",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      },
      {
        "stt": 7,
        "maphuongxa": "27382",
        "tenphuongxa": "Phường 7",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      },
      {
        "stt": 8,
        "maphuongxa": "27376",
        "tenphuongxa": "Phường 8",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      },
      {
        "stt": 9,
        "maphuongxa": "27352",
        "tenphuongxa": "Phường 9",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      },
      {
        "stt": 10,
        "maphuongxa": "27385",
        "tenphuongxa": "Phường 10",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      },
      {
        "stt": 11,
        "maphuongxa": "27364",
        "tenphuongxa": "Phường 11",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      },
      {
        "stt": 12,
        "maphuongxa": "27358",
        "tenphuongxa": "Phường 12",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      },
      {
        "stt": 13,
        "maphuongxa": "27349",
        "tenphuongxa": "Phường 13",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      },
      {
        "stt": 14,
        "maphuongxa": "27346",
        "tenphuongxa": "Phường 14",
        "caphanhchinh": "Phường",
        "maquanhuyen": 775
      }
    ]
  },
  {
    "stt": 7,
    "maquanhuyen": 778,
    "tenquanhuyen": "Quận 7",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27478",
        "tenphuongxa": "Phường Bình Thuận",
        "caphanhchinh": "Phường",
        "maquanhuyen": 778
      },
      {
        "stt": 2,
        "maphuongxa": "27493",
        "tenphuongxa": "Phường Phú Mỹ",
        "caphanhchinh": "Phường",
        "maquanhuyen": 778
      },
      {
        "stt": 3,
        "maphuongxa": "27484",
        "tenphuongxa": "Phường Phú Thuận",
        "caphanhchinh": "Phường",
        "maquanhuyen": 778
      },
      {
        "stt": 4,
        "maphuongxa": "27475",
        "tenphuongxa": "Phường Tân Hưng",
        "caphanhchinh": "Phường",
        "maquanhuyen": 778
      },
      {
        "stt": 5,
        "maphuongxa": "27472",
        "tenphuongxa": "Phường Tân Kiểng",
        "caphanhchinh": "Phường",
        "maquanhuyen": 778
      },
      {
        "stt": 6,
        "maphuongxa": "27490",
        "tenphuongxa": "Phường Tân Phong",
        "caphanhchinh": "Phường",
        "maquanhuyen": 778
      },
      {
        "stt": 7,
        "maphuongxa": "27487",
        "tenphuongxa": "Phường Tân Phú",
        "caphanhchinh": "Phường",
        "maquanhuyen": 778
      },
      {
        "stt": 8,
        "maphuongxa": "27481",
        "tenphuongxa": "Phường Tân Quy",
        "caphanhchinh": "Phường",
        "maquanhuyen": 778
      },
      {
        "stt": 9,
        "maphuongxa": "27466",
        "tenphuongxa": "Phường Tân Thuận Đông",
        "caphanhchinh": "Phường",
        "maquanhuyen": 778
      },
      {
        "stt": 10,
        "maphuongxa": "27469",
        "tenphuongxa": "Phường Tân Thuận Tây",
        "caphanhchinh": "Phường",
        "maquanhuyen": 778
      }
    ]
  },
  {
    "stt": 8,
    "maquanhuyen": 776,
    "tenquanhuyen": "Quận 8",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27394",
        "tenphuongxa": "Phường 1",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 2,
        "maphuongxa": "27391",
        "tenphuongxa": "Phường 2",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 3,
        "maphuongxa": "27397",
        "tenphuongxa": "Phường 3",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 4,
        "maphuongxa": "27409",
        "tenphuongxa": "Phường 4",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 5,
        "maphuongxa": "27418",
        "tenphuongxa": "Phường 5",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 6,
        "maphuongxa": "27424",
        "tenphuongxa": "Phường 6",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 7,
        "maphuongxa": "27433",
        "tenphuongxa": "Phường 7",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 8,
        "maphuongxa": "27388",
        "tenphuongxa": "Phường 8",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 9,
        "maphuongxa": "27403",
        "tenphuongxa": "Phường 9",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 10,
        "maphuongxa": "27406",
        "tenphuongxa": "Phường 10",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 11,
        "maphuongxa": "27400",
        "tenphuongxa": "Phường 11",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 12,
        "maphuongxa": "27415",
        "tenphuongxa": "Phường 12",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 13,
        "maphuongxa": "27412",
        "tenphuongxa": "Phường 13",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 14,
        "maphuongxa": "27421",
        "tenphuongxa": "Phường 14",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 15,
        "maphuongxa": "27427",
        "tenphuongxa": "Phường 15",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      },
      {
        "stt": 16,
        "maphuongxa": "27430",
        "tenphuongxa": "Phường 16",
        "caphanhchinh": "Phường",
        "maquanhuyen": 776
      }
    ]
  },
  {
    "stt": 9,
    "maquanhuyen": 763,
    "tenquanhuyen": "Quận 9",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "26839",
        "tenphuongxa": "Phường Hiệp Phú",
        "caphanhchinh": "Phường",
        "maquanhuyen": 763
      },
      {
        "stt": 2,
        "maphuongxa": "26830",
        "tenphuongxa": "Phường Long Bình",
        "caphanhchinh": "Phường",
        "maquanhuyen": 763
      },
      {
        "stt": 3,
        "maphuongxa": "26857",
        "tenphuongxa": "Phường Long Phước",
        "caphanhchinh": "Phường",
        "maquanhuyen": 763
      },
      {
        "stt": 4,
        "maphuongxa": "26833",
        "tenphuongxa": "Phường Long Thạnh Mỹ",
        "caphanhchinh": "Phường",
        "maquanhuyen": 763
      },
      {
        "stt": 5,
        "maphuongxa": "26860",
        "tenphuongxa": "Phường Long Trường",
        "caphanhchinh": "Phường",
        "maquanhuyen": 763
      },
      {
        "stt": 6,
        "maphuongxa": "26866",
        "tenphuongxa": "Phường Phú Hữu",
        "caphanhchinh": "Phường",
        "maquanhuyen": 763
      },
      {
        "stt": 7,
        "maphuongxa": "26863",
        "tenphuongxa": "Phường Phước Bình",
        "caphanhchinh": "Phường",
        "maquanhuyen": 763
      },
      {
        "stt": 8,
        "maphuongxa": "26851",
        "tenphuongxa": "Phường Phước Long A",
        "caphanhchinh": "Phường",
        "maquanhuyen": 763
      },
      {
        "stt": 9,
        "maphuongxa": "26848",
        "tenphuongxa": "Phường Phước Long B",
        "caphanhchinh": "Phường",
        "maquanhuyen": 763
      },
      {
        "stt": 10,
        "maphuongxa": "26842",
        "tenphuongxa": "Phường Tăng Nhơn Phú A",
        "caphanhchinh": "Phường",
        "maquanhuyen": 763
      },
      {
        "stt": 11,
        "maphuongxa": "26845",
        "tenphuongxa": "Phường Tăng Nhơn Phú B",
        "caphanhchinh": "Phường",
        "maquanhuyen": 763
      },
      {
        "stt": 12,
        "maphuongxa": "26836",
        "tenphuongxa": "Phường Tân Phú",
        "caphanhchinh": "Phường",
        "maquanhuyen": 763
      },
      {
        "stt": 13,
        "maphuongxa": "26854",
        "tenphuongxa": "Phường Trường Thạnh",
        "caphanhchinh": "Phường",
        "maquanhuyen": 763
      }
    ]
  },
  {
    "stt": 10,
    "maquanhuyen": 771,
    "tenquanhuyen": "Quận 10",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27184",
        "tenphuongxa": "Phường 1",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 2,
        "maphuongxa": "27190",
        "tenphuongxa": "Phường 2",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 3,
        "maphuongxa": "27205",
        "tenphuongxa": "Phường 3",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 4,
        "maphuongxa": "27193",
        "tenphuongxa": "Phường 4",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 5,
        "maphuongxa": "27199",
        "tenphuongxa": "Phường 5",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 6,
        "maphuongxa": "27202",
        "tenphuongxa": "Phường 6",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 7,
        "maphuongxa": "27196",
        "tenphuongxa": "Phường 7",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 8,
        "maphuongxa": "27187",
        "tenphuongxa": "Phường 8",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 9,
        "maphuongxa": "27181",
        "tenphuongxa": "Phường 9",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 10,
        "maphuongxa": "27178",
        "tenphuongxa": "Phường 10",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 11,
        "maphuongxa": "27175",
        "tenphuongxa": "Phường 11",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 12,
        "maphuongxa": "27172",
        "tenphuongxa": "Phường 12",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 13,
        "maphuongxa": "27166",
        "tenphuongxa": "Phường 13",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 14,
        "maphuongxa": "27169",
        "tenphuongxa": "Phường 14",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      },
      {
        "stt": 15,
        "maphuongxa": "27163",
        "tenphuongxa": "Phường 15",
        "caphanhchinh": "Phường",
        "maquanhuyen": 771
      }
    ]
  },
  {
    "stt": 11,
    "maquanhuyen": 772,
    "tenquanhuyen": "Quận 11",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27247",
        "tenphuongxa": "Phường 1",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 2,
        "maphuongxa": "27250",
        "tenphuongxa": "Phường 2",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 3,
        "maphuongxa": "27220",
        "tenphuongxa": "Phường 3",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 4,
        "maphuongxa": "27244",
        "tenphuongxa": "Phường 4",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 5,
        "maphuongxa": "27211",
        "tenphuongxa": "Phường 5",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 6,
        "maphuongxa": "27241",
        "tenphuongxa": "Phường 6",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 7,
        "maphuongxa": "27238",
        "tenphuongxa": "Phường 7",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 8,
        "maphuongxa": "27229",
        "tenphuongxa": "Phường 8",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 9,
        "maphuongxa": "27232",
        "tenphuongxa": "Phường 9",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 10,
        "maphuongxa": "27223",
        "tenphuongxa": "Phường 10",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 11,
        "maphuongxa": "27217",
        "tenphuongxa": "Phường 11",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 12,
        "maphuongxa": "27235",
        "tenphuongxa": "Phường 12",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 13,
        "maphuongxa": "27226",
        "tenphuongxa": "Phường 13",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 14,
        "maphuongxa": "27214",
        "tenphuongxa": "Phường 14",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 15,
        "maphuongxa": "27208",
        "tenphuongxa": "Phường 15",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      },
      {
        "stt": 16,
        "maphuongxa": "27253",
        "tenphuongxa": "Phường 16",
        "caphanhchinh": "Phường",
        "maquanhuyen": 772
      }
    ]
  },
  {
    "stt": 12,
    "maquanhuyen": 761,
    "tenquanhuyen": "Quận 12",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "26779",
        "tenphuongxa": "Phường An Phú Đông",
        "caphanhchinh": "Phường",
        "maquanhuyen": 761
      },
      {
        "stt": 2,
        "maphuongxa": "26788",
        "tenphuongxa": "Phường Đông Hưng Thuận",
        "caphanhchinh": "Phường",
        "maquanhuyen": 761
      },
      {
        "stt": 3,
        "maphuongxa": "26770",
        "tenphuongxa": "Phường Hiệp Thành",
        "caphanhchinh": "Phường",
        "maquanhuyen": 761
      },
      {
        "stt": 4,
        "maphuongxa": "26776",
        "tenphuongxa": "Phường Tân Chánh Hiệp",
        "caphanhchinh": "Phường",
        "maquanhuyen": 761
      },
      {
        "stt": 5,
        "maphuongxa": "26787",
        "tenphuongxa": "Phường Tân Hưng Thuận",
        "caphanhchinh": "Phường",
        "maquanhuyen": 761
      },
      {
        "stt": 6,
        "maphuongxa": "26782",
        "tenphuongxa": "Phường Tân Thới Hiệp",
        "caphanhchinh": "Phường",
        "maquanhuyen": 761
      },
      {
        "stt": 7,
        "maphuongxa": "26791",
        "tenphuongxa": "Phường Tân Thới Nhất",
        "caphanhchinh": "Phường",
        "maquanhuyen": 761
      },
      {
        "stt": 8,
        "maphuongxa": "26767",
        "tenphuongxa": "Phường Thạnh Lộc",
        "caphanhchinh": "Phường",
        "maquanhuyen": 761
      },
      {
        "stt": 9,
        "maphuongxa": "26764",
        "tenphuongxa": "Phường Thạnh Xuân",
        "caphanhchinh": "Phường",
        "maquanhuyen": 761
      },
      {
        "stt": 10,
        "maphuongxa": "26773",
        "tenphuongxa": "Phường Thới An",
        "caphanhchinh": "Phường",
        "maquanhuyen": 761
      },
      {
        "stt": 11,
        "maphuongxa": "26785",
        "tenphuongxa": "Phường Trung Mỹ Tây",
        "caphanhchinh": "Phường",
        "maquanhuyen": 761
      }
    ]
  },
  {
    "stt": 13,
    "maquanhuyen": 777,
    "tenquanhuyen": "Quận Bình Tân",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27460",
        "tenphuongxa": "Phường An Lạc",
        "caphanhchinh": "Phường",
        "maquanhuyen": 777
      },
      {
        "stt": 2,
        "maphuongxa": "27463",
        "tenphuongxa": "Phường An Lạc A",
        "caphanhchinh": "Phường",
        "maquanhuyen": 777
      },
      {
        "stt": 3,
        "maphuongxa": "27436",
        "tenphuongxa": "Phường Bình Hưng Hòa",
        "caphanhchinh": "Phường",
        "maquanhuyen": 777
      },
      {
        "stt": 4,
        "maphuongxa": "27439",
        "tenphuongxa": "Phường Bình Hưng Hoà A",
        "caphanhchinh": "Phường",
        "maquanhuyen": 777
      },
      {
        "stt": 5,
        "maphuongxa": "27442",
        "tenphuongxa": "Phường Bình Hưng Hoà B",
        "caphanhchinh": "Phường",
        "maquanhuyen": 777
      },
      {
        "stt": 6,
        "maphuongxa": "27445",
        "tenphuongxa": "Phường Bình Trị Đông",
        "caphanhchinh": "Phường",
        "maquanhuyen": 777
      },
      {
        "stt": 7,
        "maphuongxa": "27448",
        "tenphuongxa": "Phường Bình Trị Đông A",
        "caphanhchinh": "Phường",
        "maquanhuyen": 777
      },
      {
        "stt": 8,
        "maphuongxa": "27451",
        "tenphuongxa": "Phường Bình Trị Đông B",
        "caphanhchinh": "Phường",
        "maquanhuyen": 777
      },
      {
        "stt": 9,
        "maphuongxa": "27454",
        "tenphuongxa": "Phường Tân Tạo",
        "caphanhchinh": "Phường",
        "maquanhuyen": 777
      },
      {
        "stt": 10,
        "maphuongxa": "27457",
        "tenphuongxa": "Phường Tân Tạo A",
        "caphanhchinh": "Phường",
        "maquanhuyen": 777
      }
    ]
  },
  {
    "stt": 14,
    "maquanhuyen": 765,
    "tenquanhuyen": "Quận Bình Thạnh",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "26944",
        "tenphuongxa": "Phường 1",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 2,
        "maphuongxa": "26941",
        "tenphuongxa": "Phường 2",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 3,
        "maphuongxa": "26947",
        "tenphuongxa": "Phường 3",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 4,
        "maphuongxa": "26923",
        "tenphuongxa": "Phường 5",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 5,
        "maphuongxa": "26932",
        "tenphuongxa": "Phường 6",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 6,
        "maphuongxa": "26926",
        "tenphuongxa": "Phường 7",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 7,
        "maphuongxa": "26908",
        "tenphuongxa": "Phường 11",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 8,
        "maphuongxa": "26917",
        "tenphuongxa": "Phường 12",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 9,
        "maphuongxa": "26905",
        "tenphuongxa": "Phường 13",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 10,
        "maphuongxa": "26935",
        "tenphuongxa": "Phường 14",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 11,
        "maphuongxa": "26938",
        "tenphuongxa": "Phường 15",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 12,
        "maphuongxa": "26950",
        "tenphuongxa": "Phường 17",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 13,
        "maphuongxa": "26959",
        "tenphuongxa": "Phường 19",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 14,
        "maphuongxa": "26953",
        "tenphuongxa": "Phường 21",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 15,
        "maphuongxa": "26956",
        "tenphuongxa": "Phường 22",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 16,
        "maphuongxa": "26929",
        "tenphuongxa": "Phường 24",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 17,
        "maphuongxa": "26920",
        "tenphuongxa": "Phường 25",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 18,
        "maphuongxa": "26914",
        "tenphuongxa": "Phường 26",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 19,
        "maphuongxa": "26911",
        "tenphuongxa": "Phường 27",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      },
      {
        "stt": 20,
        "maphuongxa": "26962",
        "tenphuongxa": "Phường 28",
        "caphanhchinh": "Phường",
        "maquanhuyen": 765
      }
    ]
  },
  {
    "stt": 15,
    "maquanhuyen": 764,
    "tenquanhuyen": "Quận Gò Vấp",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "26896",
        "tenphuongxa": "Phường 1",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 2,
        "maphuongxa": "26902",
        "tenphuongxa": "Phường 3",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 3,
        "maphuongxa": "26893",
        "tenphuongxa": "Phường 4",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 4,
        "maphuongxa": "26887",
        "tenphuongxa": "Phường 5",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 5,
        "maphuongxa": "26876",
        "tenphuongxa": "Phường 6",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 6,
        "maphuongxa": "26890",
        "tenphuongxa": "Phường 7",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 7,
        "maphuongxa": "26898",
        "tenphuongxa": "Phường 8",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 8,
        "maphuongxa": "26897",
        "tenphuongxa": "Phường 9",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 9,
        "maphuongxa": "26884",
        "tenphuongxa": "Phường 10",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 10,
        "maphuongxa": "26899",
        "tenphuongxa": "Phường 11",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 11,
        "maphuongxa": "26881",
        "tenphuongxa": "Phường 12",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 12,
        "maphuongxa": "26872",
        "tenphuongxa": "Phường 13",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 13,
        "maphuongxa": "26882",
        "tenphuongxa": "Phường 14",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 14,
        "maphuongxa": "26869",
        "tenphuongxa": "Phường 15",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 15,
        "maphuongxa": "26878",
        "tenphuongxa": "Phường 16",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      },
      {
        "stt": 16,
        "maphuongxa": "26875",
        "tenphuongxa": "Phường 17",
        "caphanhchinh": "Phường",
        "maquanhuyen": 764
      }
    ]
  },
  {
    "stt": 16,
    "maquanhuyen": 768,
    "tenquanhuyen": "Quận Phú Nhuận",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27058",
        "tenphuongxa": "Phường 1",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 2,
        "maphuongxa": "27061",
        "tenphuongxa": "Phường 2",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 3,
        "maphuongxa": "27055",
        "tenphuongxa": "Phường 3",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 4,
        "maphuongxa": "27043",
        "tenphuongxa": "Phường 4",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 5,
        "maphuongxa": "27046",
        "tenphuongxa": "Phường 5",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 6,
        "maphuongxa": "27052",
        "tenphuongxa": "Phường 7",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 7,
        "maphuongxa": "27064",
        "tenphuongxa": "Phường 8",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 8,
        "maphuongxa": "27049",
        "tenphuongxa": "Phường 9",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 9,
        "maphuongxa": "27070",
        "tenphuongxa": "Phường 10",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 10,
        "maphuongxa": "27073",
        "tenphuongxa": "Phường 11",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 11,
        "maphuongxa": "27082",
        "tenphuongxa": "Phường 12",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 12,
        "maphuongxa": "27085",
        "tenphuongxa": "Phường 13",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 13,
        "maphuongxa": "27079",
        "tenphuongxa": "Phường 14",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 14,
        "maphuongxa": "27067",
        "tenphuongxa": "Phường 15",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      },
      {
        "stt": 15,
        "maphuongxa": "27076",
        "tenphuongxa": "Phường 17",
        "caphanhchinh": "Phường",
        "maquanhuyen": 768
      }
    ]
  },
  {
    "stt": 17,
    "maquanhuyen": 766,
    "tenquanhuyen": "Quận Tân Bình",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "26977",
        "tenphuongxa": "Phường 1",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 2,
        "maphuongxa": "26965",
        "tenphuongxa": "Phường 2",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 3,
        "maphuongxa": "26980",
        "tenphuongxa": "Phường 3",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 4,
        "maphuongxa": "26968",
        "tenphuongxa": "Phường 4",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 5,
        "maphuongxa": "26989",
        "tenphuongxa": "Phường 5",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 6,
        "maphuongxa": "26995",
        "tenphuongxa": "Phường 6",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 7,
        "maphuongxa": "26986",
        "tenphuongxa": "Phường 7",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 8,
        "maphuongxa": "26998",
        "tenphuongxa": "Phường 8",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 9,
        "maphuongxa": "27001",
        "tenphuongxa": "Phường 9",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 10,
        "maphuongxa": "26992",
        "tenphuongxa": "Phường 10",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 11,
        "maphuongxa": "26983",
        "tenphuongxa": "Phường 11",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 12,
        "maphuongxa": "26971",
        "tenphuongxa": "Phường 12",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 13,
        "maphuongxa": "26974",
        "tenphuongxa": "Phường 13",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 14,
        "maphuongxa": "27004",
        "tenphuongxa": "Phường 14",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      },
      {
        "stt": 15,
        "maphuongxa": "27007",
        "tenphuongxa": "Phường 15",
        "caphanhchinh": "Phường",
        "maquanhuyen": 766
      }
    ]
  },
  {
    "stt": 18,
    "maquanhuyen": 767,
    "tenquanhuyen": "Quận Tân Phú",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27037",
        "tenphuongxa": "Phường Hiệp Tân",
        "caphanhchinh": "Phường",
        "maquanhuyen": 767
      },
      {
        "stt": 2,
        "maphuongxa": "27034",
        "tenphuongxa": "Phường Hòa Thạnh",
        "caphanhchinh": "Phường",
        "maquanhuyen": 767
      },
      {
        "stt": 3,
        "maphuongxa": "27028",
        "tenphuongxa": "Phường Phú Thạnh",
        "caphanhchinh": "Phường",
        "maquanhuyen": 767
      },
      {
        "stt": 4,
        "maphuongxa": "27025",
        "tenphuongxa": "Phường Phú Thọ Hòa",
        "caphanhchinh": "Phường",
        "maquanhuyen": 767
      },
      {
        "stt": 5,
        "maphuongxa": "27031",
        "tenphuongxa": "Phường Phú Trung",
        "caphanhchinh": "Phường",
        "maquanhuyen": 767
      },
      {
        "stt": 6,
        "maphuongxa": "27016",
        "tenphuongxa": "Phường Sơn Kỳ",
        "caphanhchinh": "Phường",
        "maquanhuyen": 767
      },
      {
        "stt": 7,
        "maphuongxa": "27019",
        "tenphuongxa": "Phường Tân Quý",
        "caphanhchinh": "Phường",
        "maquanhuyen": 767
      },
      {
        "stt": 8,
        "maphuongxa": "27010",
        "tenphuongxa": "Phường Tân Sơn Nhì",
        "caphanhchinh": "Phường",
        "maquanhuyen": 767
      },
      {
        "stt": 9,
        "maphuongxa": "27022",
        "tenphuongxa": "Phường Tân Thành",
        "caphanhchinh": "Phường",
        "maquanhuyen": 767
      },
      {
        "stt": 10,
        "maphuongxa": "27040",
        "tenphuongxa": "Phường Tân Thới Hòa",
        "caphanhchinh": "Phường",
        "maquanhuyen": 767
      },
      {
        "stt": 11,
        "maphuongxa": "27013",
        "tenphuongxa": "Phường Tây Thạnh",
        "caphanhchinh": "Phường",
        "maquanhuyen": 767
      }
    ]
  },
  {
    "stt": 19,
    "maquanhuyen": 762,
    "tenquanhuyen": "Quận Thủ Đức",
    "caphanhchinh": "Quận",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "26797",
        "tenphuongxa": "Phường Bình Chiểu",
        "caphanhchinh": "Phường",
        "maquanhuyen": 762
      },
      {
        "stt": 2,
        "maphuongxa": "26824",
        "tenphuongxa": "Phường Bình Thọ",
        "caphanhchinh": "Phường",
        "maquanhuyen": 762
      },
      {
        "stt": 3,
        "maphuongxa": "26812",
        "tenphuongxa": "Phường Hiệp Bình Chánh",
        "caphanhchinh": "Phường",
        "maquanhuyen": 762
      },
      {
        "stt": 4,
        "maphuongxa": "26809",
        "tenphuongxa": "Phường Hiệp Bình Phước",
        "caphanhchinh": "Phường",
        "maquanhuyen": 762
      },
      {
        "stt": 5,
        "maphuongxa": "26815",
        "tenphuongxa": "Phường Linh Chiểu",
        "caphanhchinh": "Phường",
        "maquanhuyen": 762
      },
      {
        "stt": 6,
        "maphuongxa": "26821",
        "tenphuongxa": "Phường Linh Đông",
        "caphanhchinh": "Phường",
        "maquanhuyen": 762
      },
      {
        "stt": 7,
        "maphuongxa": "26818",
        "tenphuongxa": "Phường Linh Tây",
        "caphanhchinh": "Phường",
        "maquanhuyen": 762
      },
      {
        "stt": 8,
        "maphuongxa": "26800",
        "tenphuongxa": "Phường Linh Trung",
        "caphanhchinh": "Phường",
        "maquanhuyen": 762
      },
      {
        "stt": 9,
        "maphuongxa": "26794",
        "tenphuongxa": "Phường Linh Xuân",
        "caphanhchinh": "Phường",
        "maquanhuyen": 762
      },
      {
        "stt": 10,
        "maphuongxa": "26803",
        "tenphuongxa": "Phường Tam Bình",
        "caphanhchinh": "Phường",
        "maquanhuyen": 762
      },
      {
        "stt": 11,
        "maphuongxa": "26806",
        "tenphuongxa": "Phường Tam Phú",
        "caphanhchinh": "Phường",
        "maquanhuyen": 762
      },
      {
        "stt": 12,
        "maphuongxa": "26827",
        "tenphuongxa": "Phường Trường Thọ",
        "caphanhchinh": "Phường",
        "maquanhuyen": 762
      }
    ]
  },
  {
    "stt": 20,
    "maquanhuyen": 785,
    "tenquanhuyen": "Huyện Bình Chánh",
    "caphanhchinh": "Huyện",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27595",
        "tenphuongxa": "Thị trấn Tân Túc",
        "caphanhchinh": "Thị trấn",
        "maquanhuyen": 785
      },
      {
        "stt": 2,
        "maphuongxa": "27625",
        "tenphuongxa": "Xã An Phú Tây",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 3,
        "maphuongxa": "27637",
        "tenphuongxa": "Xã Bình Chánh",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 4,
        "maphuongxa": "27619",
        "tenphuongxa": "Xã Bình Hưng",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 5,
        "maphuongxa": "27607",
        "tenphuongxa": "Xã Bình Lợi",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 6,
        "maphuongxa": "27631",
        "tenphuongxa": "Xã Đa Phước",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 7,
        "maphuongxa": "27628",
        "tenphuongxa": "Xã Hưng Long",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 8,
        "maphuongxa": "27610",
        "tenphuongxa": "Xã Lê Minh Xuân",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 9,
        "maphuongxa": "27598",
        "tenphuongxa": "Xã Phạm Văn Hai",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 10,
        "maphuongxa": "27622",
        "tenphuongxa": "Xã Phong Phú",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 11,
        "maphuongxa": "27640",
        "tenphuongxa": "Xã Quy Đức",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 12,
        "maphuongxa": "27616",
        "tenphuongxa": "Xã Tân Kiên",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 13,
        "maphuongxa": "27613",
        "tenphuongxa": "Xã Tân Nhựt",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 14,
        "maphuongxa": "27634",
        "tenphuongxa": "Xã Tân Quý Tây",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 15,
        "maphuongxa": "27601",
        "tenphuongxa": "Xã Vĩnh Lộc A",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      },
      {
        "stt": 16,
        "maphuongxa": "27604",
        "tenphuongxa": "Xã Vĩnh Lộc B",
        "caphanhchinh": "Xã",
        "maquanhuyen": 785
      }
    ]
  },
  {
    "stt": 21,
    "maquanhuyen": 787,
    "tenquanhuyen": "Huyện Cần Giờ",
    "caphanhchinh": "Huyện",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27664",
        "tenphuongxa": "Thị trấn Cần Thạnh",
        "caphanhchinh": "Thị trấn",
        "maquanhuyen": 787
      },
      {
        "stt": 2,
        "maphuongxa": "27673",
        "tenphuongxa": "Xã An Thới Đông",
        "caphanhchinh": "Xã",
        "maquanhuyen": 787
      },
      {
        "stt": 3,
        "maphuongxa": "27667",
        "tenphuongxa": "Xã Bình Khánh",
        "caphanhchinh": "Xã",
        "maquanhuyen": 787
      },
      {
        "stt": 4,
        "maphuongxa": "27679",
        "tenphuongxa": "Xã Long Hòa",
        "caphanhchinh": "Xã",
        "maquanhuyen": 787
      },
      {
        "stt": 5,
        "maphuongxa": "27682",
        "tenphuongxa": "Xã Lý Nhơn",
        "caphanhchinh": "Xã",
        "maquanhuyen": 787
      },
      {
        "stt": 6,
        "maphuongxa": "27670",
        "tenphuongxa": "Xã Tam Thôn Hiệp",
        "caphanhchinh": "Xã",
        "maquanhuyen": 787
      },
      {
        "stt": 7,
        "maphuongxa": "27676",
        "tenphuongxa": "Xã Thạnh An",
        "caphanhchinh": "Xã",
        "maquanhuyen": 787
      },
      {
        "stt": 8,
        "maphuongxa": "78700",
        "tenphuongxa": "Khu lấn biển",
        "caphanhchinh": null,
        "maquanhuyen": 787
      }
    ]
  },
  {
    "stt": 22,
    "maquanhuyen": 783,
    "tenquanhuyen": "Huyện Củ Chi",
    "caphanhchinh": "Huyện",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27496",
        "tenphuongxa": "Thị trấn Củ Chi",
        "caphanhchinh": "Thị trấn",
        "maquanhuyen": 783
      },
      {
        "stt": 2,
        "maphuongxa": "27508",
        "tenphuongxa": "Xã An Nhơn Tây",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 3,
        "maphuongxa": "27502",
        "tenphuongxa": "Xã An Phú",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 4,
        "maphuongxa": "27550",
        "tenphuongxa": "Xã Bình Mỹ",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 5,
        "maphuongxa": "27544",
        "tenphuongxa": "Xã Hòa Phú",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 6,
        "maphuongxa": "27511",
        "tenphuongxa": "Xã Nhuận Đức",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 7,
        "maphuongxa": "27514",
        "tenphuongxa": "Xã Phạm Văn Cội",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 8,
        "maphuongxa": "27517",
        "tenphuongxa": "Xã Phú Hòa Đông",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 9,
        "maphuongxa": "27499",
        "tenphuongxa": "Xã Phú Mỹ Hưng",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 10,
        "maphuongxa": "27529",
        "tenphuongxa": "Xã Phước Hiệp",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 11,
        "maphuongxa": "27526",
        "tenphuongxa": "Xã Phước Thạnh",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 12,
        "maphuongxa": "27535",
        "tenphuongxa": "Xã Phước Vĩnh An",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 13,
        "maphuongxa": "27532",
        "tenphuongxa": "Xã Tân An Hội",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 14,
        "maphuongxa": "27553",
        "tenphuongxa": "Xã Tân Phú Trung",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 15,
        "maphuongxa": "27547",
        "tenphuongxa": "Xã Tân Thạnh Đông",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 16,
        "maphuongxa": "27541",
        "tenphuongxa": "Xã Tân Thạnh Tây",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 17,
        "maphuongxa": "27556",
        "tenphuongxa": "Xã Tân Thông Hội",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 18,
        "maphuongxa": "27538",
        "tenphuongxa": "Xã Thái Mỹ",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 19,
        "maphuongxa": "27523",
        "tenphuongxa": "Xã Trung An",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 20,
        "maphuongxa": "27520",
        "tenphuongxa": "Xã Trung Lập Hạ",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      },
      {
        "stt": 21,
        "maphuongxa": "27505",
        "tenphuongxa": "Xã Trung Lập Thượng",
        "caphanhchinh": "Xã",
        "maquanhuyen": 783
      }
    ]
  },
  {
    "stt": 23,
    "maquanhuyen": 784,
    "tenquanhuyen": "Huyện Hóc Môn",
    "caphanhchinh": "Huyện",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27559",
        "tenphuongxa": "Thị trấn Hóc Môn",
        "caphanhchinh": "Thị trấn",
        "maquanhuyen": 784
      },
      {
        "stt": 2,
        "maphuongxa": "27592",
        "tenphuongxa": "Xã Bà Điểm",
        "caphanhchinh": "Xã",
        "maquanhuyen": 784
      },
      {
        "stt": 3,
        "maphuongxa": "27568",
        "tenphuongxa": "Xã Đông Thạnh",
        "caphanhchinh": "Xã",
        "maquanhuyen": 784
      },
      {
        "stt": 4,
        "maphuongxa": "27565",
        "tenphuongxa": "Xã Nhị Bình",
        "caphanhchinh": "Xã",
        "maquanhuyen": 784
      },
      {
        "stt": 5,
        "maphuongxa": "27562",
        "tenphuongxa": "Xã Tân Hiệp",
        "caphanhchinh": "Xã",
        "maquanhuyen": 784
      },
      {
        "stt": 6,
        "maphuongxa": "27571",
        "tenphuongxa": "Xã Tân Thới Nhì",
        "caphanhchinh": "Xã",
        "maquanhuyen": 784
      },
      {
        "stt": 7,
        "maphuongxa": "27580",
        "tenphuongxa": "Xã Tân Xuân",
        "caphanhchinh": "Xã",
        "maquanhuyen": 784
      },
      {
        "stt": 8,
        "maphuongxa": "27574",
        "tenphuongxa": "Xã Thới Tam Thôn",
        "caphanhchinh": "Xã",
        "maquanhuyen": 784
      },
      {
        "stt": 9,
        "maphuongxa": "27586",
        "tenphuongxa": "Xã Trung Chánh",
        "caphanhchinh": "Xã",
        "maquanhuyen": 784
      },
      {
        "stt": 10,
        "maphuongxa": "27583",
        "tenphuongxa": "Xã Xuân Thới Đông",
        "caphanhchinh": "Xã",
        "maquanhuyen": 784
      },
      {
        "stt": 11,
        "maphuongxa": "27577",
        "tenphuongxa": "Xã Xuân Thới Sơn",
        "caphanhchinh": "Xã",
        "maquanhuyen": 784
      },
      {
        "stt": 12,
        "maphuongxa": "27589",
        "tenphuongxa": "Xã Xuân Thới Thượng",
        "caphanhchinh": "Xã",
        "maquanhuyen": 784
      }
    ]
  },
  {
    "stt": 24,
    "maquanhuyen": 786,
    "tenquanhuyen": "Huyện Nhà Bè",
    "caphanhchinh": "Huyện",
    "wards": [
      {
        "stt": 1,
        "maphuongxa": "27643",
        "tenphuongxa": "Thị trấn Nhà Bè",
        "caphanhchinh": "Thị trấn",
        "maquanhuyen": 786
      },
      {
        "stt": 2,
        "maphuongxa": "27661",
        "tenphuongxa": "Xã Hiệp Phước",
        "caphanhchinh": "Xã",
        "maquanhuyen": 786
      },
      {
        "stt": 3,
        "maphuongxa": "27658",
        "tenphuongxa": "Xã Long Thới",
        "caphanhchinh": "Xã",
        "maquanhuyen": 786
      },
      {
        "stt": 4,
        "maphuongxa": "27652",
        "tenphuongxa": "Xã Nhơn Đức",
        "caphanhchinh": "Xã",
        "maquanhuyen": 786
      },
      {
        "stt": 5,
        "maphuongxa": "27646",
        "tenphuongxa": "Xã Phước Kiển",
        "caphanhchinh": "Xã",
        "maquanhuyen": 786
      },
      {
        "stt": 6,
        "maphuongxa": "27649",
        "tenphuongxa": "Xã Phước Lộc",
        "caphanhchinh": "Xã",
        "maquanhuyen": 786
      },
      {
        "stt": 7,
        "maphuongxa": "27655",
        "tenphuongxa": "Xã Phú Xuân",
        "caphanhchinh": "Xã",
        "maquanhuyen": 786
      }
    ]
  },
  {
    "stt": 25,
    "maquanhuyen": 76905,
    "tenquanhuyen": "Khu Đô Thị Mới Thủ Thiêm",
    "caphanhchinh": null,
    "wards": null
  },
  {
    "stt": 26,
    "maquanhuyen": 78733,
    "tenquanhuyen": "Khu Đô Thị Du Lịch Biển Cần Giờ 2870 ha",
    "caphanhchinh": null,
    "wards": null
  },
  {
    "stt": 27,
    "maquanhuyen": 77801,
    "tenquanhuyen": "Đồ án Khu dân cư phường Tân Hưng",
    "caphanhchinh": null,
    "wards": null
  }
];
