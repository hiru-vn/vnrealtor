final listCadastral = _rawJson.map((e) => Cadastral.fromJson(e)).toList();

class Cadastral {
  String? id;
  String? idDiaChinh;
  String? tenDiaChinh;
  String? kinhTuyenTruc;
  String? stt;
  String? keyTimKiem;
  String? createdAt;
  String? updatedAt;

  Cadastral(
      {this.id,
      this.idDiaChinh,
      this.tenDiaChinh,
      this.kinhTuyenTruc,
      this.stt,
      this.keyTimKiem,
      this.createdAt,
      this.updatedAt});

  Cadastral.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idDiaChinh = json['idDiaChinh'];
    tenDiaChinh = json['tenDiaChinh'];
    kinhTuyenTruc = json['kinhTuyenTruc'];
    stt = json['stt'];
    keyTimKiem = json['keyTimKiem'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idDiaChinh'] = this.idDiaChinh;
    data['tenDiaChinh'] = this.tenDiaChinh;
    data['kinhTuyenTruc'] = this.kinhTuyenTruc;
    data['stt'] = this.stt;
    data['keyTimKiem'] = this.keyTimKiem;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

final _rawJson = [
  {
    "id": "61b60d0352535959b8728df7",
    "idDiaChinh": "DC56",
    "tenDiaChinh": "Thành phố Hồ Chí Minh",
    "kinhTuyenTruc": "105.75",
    "stt": "56",
    "keyTimKiem": "THANHPHOHOCHIMINH",
    "createdAt": "2021-12-12T14:54:02.933Z",
    "updatedAt": "2021-12-12T14:54:02.933Z"
  },
  {
    "id": "61b60d0352535959b8728dd7",
    "idDiaChinh": "DC24",
    "tenDiaChinh": "Hà Nội",
    "kinhTuyenTruc": "105.00",
    "stt": "24",
    "keyTimKiem": "HANOI",
    "createdAt": "2021-12-12T14:54:02.926Z",
    "updatedAt": "2021-12-12T14:54:02.926Z"
  },
  {
    "id": "61b60d0352535959b8728dde",
    "idDiaChinh": "DC31",
    "tenDiaChinh": "Khánh Hoà",
    "kinhTuyenTruc": "108.25",
    "stt": "31",
    "keyTimKiem": "KHANHHOA",
    "createdAt": "2021-12-12T14:54:02.927Z",
    "updatedAt": "2021-12-12T14:54:02.927Z"
  },
  {
    "id": "61b60d0352535959b8728dc6",
    "idDiaChinh": "DC07",
    "tenDiaChinh": "Bến Tre",
    "kinhTuyenTruc": "105.75",
    "stt": "7",
    "keyTimKiem": "BENTRE",
    "createdAt": "2021-12-12T14:54:02.920Z",
    "updatedAt": "2021-12-12T14:54:02.920Z"
  },
  {
    "id": "61b60d0352535959b8728dcc",
    "idDiaChinh": "DC13",
    "tenDiaChinh": "Cao Bằng",
    "kinhTuyenTruc": "105.75",
    "stt": "13",
    "keyTimKiem": "CAOBANG",
    "createdAt": "2021-12-12T14:54:02.922Z",
    "updatedAt": "2021-12-12T14:54:02.922Z"
  },
  {
    "id": "61b60d0352535959b8728dcf",
    "idDiaChinh": "DC16",
    "tenDiaChinh": "Đắk Lắk",
    "kinhTuyenTruc": "108.50",
    "stt": "16",
    "keyTimKiem": "DAKLAK",
    "createdAt": "2021-12-12T14:54:02.923Z",
    "updatedAt": "2021-12-12T14:54:02.923Z"
  },
  {
    "id": "61b60d0352535959b8728dd0",
    "idDiaChinh": "DC17",
    "tenDiaChinh": "Đắk Nông",
    "kinhTuyenTruc": "108.50",
    "stt": "17",
    "keyTimKiem": "DAKNONG",
    "createdAt": "2021-12-12T14:54:02.923Z",
    "updatedAt": "2021-12-12T14:54:02.923Z"
  },
  {
    "id": "61b60d0352535959b8728dc0",
    "idDiaChinh": "DC01",
    "tenDiaChinh": "An Giang",
    "kinhTuyenTruc": "104.75",
    "stt": "1",
    "keyTimKiem": "ANGIANG",
    "createdAt": "2021-12-12T14:54:02.918Z",
    "updatedAt": "2021-12-12T14:54:02.918Z"
  },
  {
    "id": "61b60d0352535959b8728dd3",
    "idDiaChinh": "DC20",
    "tenDiaChinh": "Đồng Tháp",
    "kinhTuyenTruc": "105.00",
    "stt": "20",
    "keyTimKiem": "DONGTHAP",
    "createdAt": "2021-12-12T14:54:02.925Z",
    "updatedAt": "2021-12-12T14:54:02.925Z"
  },
  {
    "id": "61b60d0352535959b8728dcd",
    "idDiaChinh": "DC14",
    "tenDiaChinh": "Cần Thơ",
    "kinhTuyenTruc": "105.00",
    "stt": "14",
    "keyTimKiem": "CANTHO",
    "createdAt": "2021-12-12T14:54:02.922Z",
    "updatedAt": "2021-12-12T14:54:02.922Z"
  },
  {
    "id": "61b60d0352535959b8728dce",
    "idDiaChinh": "DC15",
    "tenDiaChinh": "Đà Nẵng",
    "kinhTuyenTruc": "107.75",
    "stt": "15",
    "keyTimKiem": "DANANG",
    "createdAt": "2021-12-12T14:54:02.923Z",
    "updatedAt": "2021-12-12T14:54:02.923Z"
  },
  {
    "id": "61b60d0352535959b8728de0",
    "idDiaChinh": "DC33",
    "tenDiaChinh": "Kon Tum",
    "kinhTuyenTruc": "107.50",
    "stt": "33",
    "keyTimKiem": "KONTUM",
    "createdAt": "2021-12-12T14:54:02.928Z",
    "updatedAt": "2021-12-12T14:54:02.928Z"
  },
  {
    "id": "61b60d0352535959b8728deb",
    "idDiaChinh": "DC44",
    "tenDiaChinh": "Phú Yên",
    "kinhTuyenTruc": "108.50",
    "stt": "44",
    "keyTimKiem": "PHUYEN",
    "createdAt": "2021-12-12T14:54:02.930Z",
    "updatedAt": "2021-12-12T14:54:02.930Z"
  },
  {
    "id": "61b60d0352535959b8728df6",
    "idDiaChinh": "DC55",
    "tenDiaChinh": "Thanh Hoá",
    "kinhTuyenTruc": "105.00",
    "stt": "55",
    "keyTimKiem": "THANHHOA",
    "createdAt": "2021-12-12T14:54:02.933Z",
    "updatedAt": "2021-12-12T14:54:02.933Z"
  },
  {
    "id": "61b60d0352535959b8728dd1",
    "idDiaChinh": "DC18",
    "tenDiaChinh": "Điện Biên",
    "kinhTuyenTruc": "103.00",
    "stt": "18",
    "keyTimKiem": "DIENBIEN",
    "createdAt": "2021-12-12T14:54:02.924Z",
    "updatedAt": "2021-12-12T14:54:02.924Z"
  },
  {
    "id": "61b60d0352535959b8728df2",
    "idDiaChinh": "DC51",
    "tenDiaChinh": "Sơn La",
    "kinhTuyenTruc": "104.00",
    "stt": "51",
    "keyTimKiem": "SONLA",
    "createdAt": "2021-12-12T14:54:02.931Z",
    "updatedAt": "2021-12-12T14:54:02.931Z"
  },
  {
    "id": "61b60d0352535959b8728df3",
    "idDiaChinh": "DC52",
    "tenDiaChinh": "Tây Ninh",
    "kinhTuyenTruc": "105.50",
    "stt": "52",
    "keyTimKiem": "TAYNINH",
    "createdAt": "2021-12-12T14:54:02.931Z",
    "updatedAt": "2021-12-12T14:54:02.931Z"
  },
  {
    "id": "61b60d0352535959b8728def",
    "idDiaChinh": "DC48",
    "tenDiaChinh": "Quảng Ninh",
    "kinhTuyenTruc": "107.75",
    "stt": "48",
    "keyTimKiem": "QUANGNINH",
    "createdAt": "2021-12-12T14:54:02.931Z",
    "updatedAt": "2021-12-12T14:54:02.931Z"
  },
  {
    "id": "61b60d0352535959b8728df4",
    "idDiaChinh": "DC53",
    "tenDiaChinh": "Thái Bình",
    "kinhTuyenTruc": "105.50",
    "stt": "53",
    "keyTimKiem": "THAIBINH",
    "createdAt": "2021-12-12T14:54:02.932Z",
    "updatedAt": "2021-12-12T14:54:02.932Z"
  },
  {
    "id": "61b60d0352535959b8728df8",
    "idDiaChinh": "DC57",
    "tenDiaChinh": "Thừa Thiên - Huế",
    "kinhTuyenTruc": "107.00",
    "stt": "57",
    "keyTimKiem": "THUATHIEN-HUE",
    "createdAt": "2021-12-12T14:54:02.933Z",
    "updatedAt": "2021-12-12T14:54:02.933Z"
  },
  {
    "id": "61b60d0352535959b8728dd9",
    "idDiaChinh": "DC26",
    "tenDiaChinh": "Hà Tĩnh",
    "kinhTuyenTruc": "105.50",
    "stt": "26",
    "keyTimKiem": "HATINH",
    "createdAt": "2021-12-12T14:54:02.926Z",
    "updatedAt": "2021-12-12T14:54:02.926Z"
  },
  {
    "id": "61b60d0352535959b8728ded",
    "idDiaChinh": "DC46",
    "tenDiaChinh": "Quảng Nam",
    "kinhTuyenTruc": "107.75",
    "stt": "46",
    "keyTimKiem": "QUANGNAM",
    "createdAt": "2021-12-12T14:54:02.931Z",
    "updatedAt": "2021-12-12T14:54:02.931Z"
  },
  {
    "id": "61b60d0352535959b8728dd5",
    "idDiaChinh": "DC22",
    "tenDiaChinh": "Hà Giang",
    "kinhTuyenTruc": "105.50",
    "stt": "22",
    "keyTimKiem": "HAGIANG",
    "createdAt": "2021-12-12T14:54:02.925Z",
    "updatedAt": "2021-12-12T14:54:02.925Z"
  },
  {
    "id": "61b60d0352535959b8728dd4",
    "idDiaChinh": "DC21",
    "tenDiaChinh": "Gia Lai",
    "kinhTuyenTruc": "108.50",
    "stt": "21",
    "keyTimKiem": "GIALAI",
    "createdAt": "2021-12-12T14:54:02.925Z",
    "updatedAt": "2021-12-12T14:54:02.925Z"
  },
  {
    "id": "61b60d0352535959b8728ddd",
    "idDiaChinh": "DC30",
    "tenDiaChinh": "Hưng Yên",
    "kinhTuyenTruc": "105.50",
    "stt": "30",
    "keyTimKiem": "HUNGYEN",
    "createdAt": "2021-12-12T14:54:02.927Z",
    "updatedAt": "2021-12-12T14:54:02.927Z"
  },
  {
    "id": "61b60d0352535959b8728df9",
    "idDiaChinh": "DC58",
    "tenDiaChinh": "Tiền Giang",
    "kinhTuyenTruc": "105.75",
    "stt": "58",
    "keyTimKiem": "TIENGIANG",
    "createdAt": "2021-12-12T14:54:02.934Z",
    "updatedAt": "2021-12-12T14:54:02.934Z"
  },
  {
    "id": "61b60d0352535959b8728dfd",
    "idDiaChinh": "DC62",
    "tenDiaChinh": "Vĩnh Phúc",
    "kinhTuyenTruc": "105.00",
    "stt": "62",
    "keyTimKiem": "VINHPHUC",
    "createdAt": "2021-12-12T14:54:02.936Z",
    "updatedAt": "2021-12-12T14:54:02.936Z"
  },
  {
    "id": "61b60d0352535959b8728ddc",
    "idDiaChinh": "DC29",
    "tenDiaChinh": "Hoà Bình",
    "kinhTuyenTruc": "106.00",
    "stt": "29",
    "keyTimKiem": "HOABINH",
    "createdAt": "2021-12-12T14:54:02.927Z",
    "updatedAt": "2021-12-12T14:54:02.927Z"
  },
  {
    "id": "61b60d0352535959b8728dca",
    "idDiaChinh": "DC11",
    "tenDiaChinh": "Bình Thuận",
    "kinhTuyenTruc": "108.50",
    "stt": "11",
    "keyTimKiem": "BINHTHUAN",
    "createdAt": "2021-12-12T14:54:02.921Z",
    "updatedAt": "2021-12-12T14:54:02.921Z"
  },
  {
    "id": "61b60d0352535959b8728ddb",
    "idDiaChinh": "DC28",
    "tenDiaChinh": "Hải Phòng",
    "kinhTuyenTruc": "105.75",
    "stt": "28",
    "keyTimKiem": "HAIPHONG",
    "createdAt": "2021-12-12T14:54:02.927Z",
    "updatedAt": "2021-12-12T14:54:02.927Z"
  },
  {
    "id": "61b60d0352535959b8728dc3",
    "idDiaChinh": "DC04",
    "tenDiaChinh": "Bắc Giang",
    "kinhTuyenTruc": "107.00",
    "stt": "4",
    "keyTimKiem": "BACGIANG",
    "createdAt": "2021-12-12T14:54:02.919Z",
    "updatedAt": "2021-12-12T14:54:02.919Z"
  },
  {
    "id": "61b60d0352535959b8728dd6",
    "idDiaChinh": "DC23",
    "tenDiaChinh": "Hà Nam",
    "kinhTuyenTruc": "105.00",
    "stt": "23",
    "keyTimKiem": "HANAM",
    "createdAt": "2021-12-12T14:54:02.926Z",
    "updatedAt": "2021-12-12T14:54:02.926Z"
  },
  {
    "id": "61b60d0352535959b8728de1",
    "idDiaChinh": "DC34",
    "tenDiaChinh": "Lai Châu",
    "kinhTuyenTruc": "103.00",
    "stt": "34",
    "keyTimKiem": "LAICHAU",
    "createdAt": "2021-12-12T14:54:02.928Z",
    "updatedAt": "2021-12-12T14:54:02.928Z"
  },
  {
    "id": "61b60d0352535959b8728de2",
    "idDiaChinh": "DC35",
    "tenDiaChinh": "Lạng Sơn",
    "kinhTuyenTruc": "107.25",
    "stt": "35",
    "keyTimKiem": "LANGSON",
    "createdAt": "2021-12-12T14:54:02.928Z",
    "updatedAt": "2021-12-12T14:54:02.928Z"
  },
  {
    "id": "61b60d0352535959b8728dfb",
    "idDiaChinh": "DC60",
    "tenDiaChinh": "Tuyên Quang",
    "kinhTuyenTruc": "106.00",
    "stt": "60",
    "keyTimKiem": "TUYENQUANG",
    "createdAt": "2021-12-12T14:54:02.935Z",
    "updatedAt": "2021-12-12T14:54:02.935Z"
  },
  {
    "id": "61b60d0352535959b8728dfc",
    "idDiaChinh": "DC61",
    "tenDiaChinh": "Vĩnh Long",
    "kinhTuyenTruc": "105.50",
    "stt": "61",
    "keyTimKiem": "VINHLONG",
    "createdAt": "2021-12-12T14:54:02.936Z",
    "updatedAt": "2021-12-12T14:54:02.936Z"
  },
  {
    "id": "61b60d0352535959b8728de8",
    "idDiaChinh": "DC41",
    "tenDiaChinh": "Ninh Bình",
    "kinhTuyenTruc": "105.00",
    "stt": "41",
    "keyTimKiem": "NINHBINH",
    "createdAt": "2021-12-12T14:54:02.929Z",
    "updatedAt": "2021-12-12T14:54:02.929Z"
  },
  {
    "id": "61b60d0352535959b8728dfa",
    "idDiaChinh": "DC59",
    "tenDiaChinh": "Trà Vinh",
    "kinhTuyenTruc": "105.50",
    "stt": "59",
    "keyTimKiem": "TRAVINH",
    "createdAt": "2021-12-12T14:54:02.934Z",
    "updatedAt": "2021-12-12T14:54:02.934Z"
  },
  {
    "id": "61b60d0352535959b8728dcb",
    "idDiaChinh": "DC12",
    "tenDiaChinh": "Cà Mau",
    "kinhTuyenTruc": "104.50",
    "stt": "12",
    "keyTimKiem": "CAMAU",
    "createdAt": "2021-12-12T14:54:02.922Z",
    "updatedAt": "2021-12-12T14:54:02.922Z"
  },
  {
    "id": "61b60d0352535959b8728de7",
    "idDiaChinh": "DC40",
    "tenDiaChinh": "Nghệ An",
    "kinhTuyenTruc": "104.75",
    "stt": "40",
    "keyTimKiem": "NGHEAN",
    "createdAt": "2021-12-12T14:54:02.929Z",
    "updatedAt": "2021-12-12T14:54:02.929Z"
  },
  {
    "id": "61b60d0352535959b8728de9",
    "idDiaChinh": "DC42",
    "tenDiaChinh": "Ninh Thuận",
    "kinhTuyenTruc": "108.25",
    "stt": "42",
    "keyTimKiem": "NINHTHUAN",
    "createdAt": "2021-12-12T14:54:02.930Z",
    "updatedAt": "2021-12-12T14:54:02.930Z"
  },
  {
    "id": "61b60d0352535959b8728dfe",
    "idDiaChinh": "DC63",
    "tenDiaChinh": "Yên Bái",
    "kinhTuyenTruc": "104.75",
    "stt": "63",
    "keyTimKiem": "YENBAI",
    "createdAt": "2021-12-12T14:54:02.936Z",
    "updatedAt": "2021-12-12T14:54:02.936Z"
  },
  {
    "id": "61b60d0352535959b8728dc7",
    "idDiaChinh": "DC08",
    "tenDiaChinh": "Bình Dương",
    "kinhTuyenTruc": "105.75",
    "stt": "8",
    "keyTimKiem": "BINHDUONG",
    "createdAt": "2021-12-12T14:54:02.921Z",
    "updatedAt": "2021-12-12T14:54:02.921Z"
  },
  {
    "id": "61b60d0352535959b8728de5",
    "idDiaChinh": "DC38",
    "tenDiaChinh": "Long An",
    "kinhTuyenTruc": "105.75",
    "stt": "38",
    "keyTimKiem": "LONGAN",
    "createdAt": "2021-12-12T14:54:02.929Z",
    "updatedAt": "2021-12-12T14:54:02.929Z"
  },
  {
    "id": "61b60d0352535959b8728dec",
    "idDiaChinh": "DC45",
    "tenDiaChinh": "Quảng Bình",
    "kinhTuyenTruc": "106.00",
    "stt": "45",
    "keyTimKiem": "QUANGBINH",
    "createdAt": "2021-12-12T14:54:02.930Z",
    "updatedAt": "2021-12-12T14:54:02.930Z"
  },
  {
    "id": "61b60d0352535959b8728dee",
    "idDiaChinh": "DC47",
    "tenDiaChinh": "Quảng Ngãi",
    "kinhTuyenTruc": "108.00",
    "stt": "47",
    "keyTimKiem": "QUANGNGAI",
    "createdAt": "2021-12-12T14:54:02.931Z",
    "updatedAt": "2021-12-12T14:54:02.931Z"
  },
  {
    "id": "61b60d0352535959b8728dd8",
    "idDiaChinh": "DC25",
    "tenDiaChinh": "Hà Tây",
    "kinhTuyenTruc": "105.00",
    "stt": "25",
    "keyTimKiem": "HATAY",
    "createdAt": "2021-12-12T14:54:02.926Z",
    "updatedAt": "2021-12-12T14:54:02.926Z"
  },
  {
    "id": "61b60d0352535959b8728dea",
    "idDiaChinh": "DC43",
    "tenDiaChinh": "Phú Thọ",
    "kinhTuyenTruc": "104.75",
    "stt": "43",
    "keyTimKiem": "PHUTHO",
    "createdAt": "2021-12-12T14:54:02.930Z",
    "updatedAt": "2021-12-12T14:54:02.930Z"
  },
  {
    "id": "61b60d0352535959b8728df0",
    "idDiaChinh": "DC49",
    "tenDiaChinh": "Quảng Trị",
    "kinhTuyenTruc": "106.25",
    "stt": "49",
    "keyTimKiem": "QUANGTRI",
    "createdAt": "2021-12-12T14:54:02.931Z",
    "updatedAt": "2021-12-12T14:54:02.931Z"
  },
  {
    "id": "61b60d0352535959b8728df1",
    "idDiaChinh": "DC50",
    "tenDiaChinh": "Sóc Trăng",
    "kinhTuyenTruc": "105.50",
    "stt": "50",
    "keyTimKiem": "SOCTRANG",
    "createdAt": "2021-12-12T14:54:02.931Z",
    "updatedAt": "2021-12-12T14:54:02.931Z"
  },
  {
    "id": "61b60d0352535959b8728df5",
    "idDiaChinh": "DC54",
    "tenDiaChinh": "Thái Nguyên",
    "kinhTuyenTruc": "106.50",
    "stt": "54",
    "keyTimKiem": "THAINGUYEN",
    "createdAt": "2021-12-12T14:54:02.932Z",
    "updatedAt": "2021-12-12T14:54:02.932Z"
  },
  {
    "id": "61b60d0352535959b8728dc5",
    "idDiaChinh": "DC06",
    "tenDiaChinh": "Bắc Ninh",
    "kinhTuyenTruc": "105.50",
    "stt": "6",
    "keyTimKiem": "BACNINH",
    "createdAt": "2021-12-12T14:54:02.920Z",
    "updatedAt": "2021-12-12T14:54:02.920Z"
  },
  {
    "id": "61b60d0352535959b8728dc1",
    "idDiaChinh": "DC02",
    "tenDiaChinh": "Bà Rịa - Vũng Tàu",
    "kinhTuyenTruc": "107.75",
    "stt": "2",
    "keyTimKiem": "BARIAVUNGTAU",
    "createdAt": "2021-12-12T14:54:02.919Z",
    "updatedAt": "2021-12-12T14:54:02.919Z"
  },
  {
    "id": "61b60d0352535959b8728dc8",
    "idDiaChinh": "DC09",
    "tenDiaChinh": "Bình Định",
    "kinhTuyenTruc": "108.25",
    "stt": "9",
    "keyTimKiem": "BINHDINH",
    "createdAt": "2021-12-12T14:54:02.921Z",
    "updatedAt": "2021-12-12T14:54:02.921Z"
  },
  {
    "id": "61b60d0352535959b8728de4",
    "idDiaChinh": "DC37",
    "tenDiaChinh": "Lâm Đồng",
    "kinhTuyenTruc": "107.75",
    "stt": "37",
    "keyTimKiem": "LAMDONG",
    "createdAt": "2021-12-12T14:54:02.928Z",
    "updatedAt": "2021-12-12T14:54:02.928Z"
  },
  {
    "id": "61b60d0352535959b8728dc9",
    "idDiaChinh": "DC10",
    "tenDiaChinh": "Bình Phước",
    "kinhTuyenTruc": "106.25",
    "stt": "10",
    "keyTimKiem": "BINHPHUOC",
    "createdAt": "2021-12-12T14:54:02.921Z",
    "updatedAt": "2021-12-12T14:54:02.921Z"
  },
  {
    "id": "61b60d0352535959b8728dd2",
    "idDiaChinh": "DC19",
    "tenDiaChinh": "Đồng Nai",
    "kinhTuyenTruc": "107.75",
    "stt": "19",
    "keyTimKiem": "DONGNAI",
    "createdAt": "2021-12-12T14:54:02.925Z",
    "updatedAt": "2021-12-12T14:54:02.925Z"
  },
  {
    "id": "61b60d0352535959b8728de3",
    "idDiaChinh": "DC36",
    "tenDiaChinh": "Lào Cai",
    "kinhTuyenTruc": "104.75",
    "stt": "36",
    "keyTimKiem": "LAOCAI",
    "createdAt": "2021-12-12T14:54:02.928Z",
    "updatedAt": "2021-12-12T14:54:02.928Z"
  },
  {
    "id": "61b60d0352535959b8728dda",
    "idDiaChinh": "DC27",
    "tenDiaChinh": "Hải Dương",
    "kinhTuyenTruc": "105.50",
    "stt": "27",
    "keyTimKiem": "HAIDUONG",
    "createdAt": "2021-12-12T14:54:02.927Z",
    "updatedAt": "2021-12-12T14:54:02.927Z"
  },
  {
    "id": "61b60d0352535959b8728dc2",
    "idDiaChinh": "DC03",
    "tenDiaChinh": "Bạc Liêu",
    "kinhTuyenTruc": "105.00",
    "stt": "3",
    "keyTimKiem": "BACLIEU",
    "createdAt": "2021-12-12T14:54:02.919Z",
    "updatedAt": "2021-12-12T14:54:02.919Z"
  },
  {
    "id": "61b60d0352535959b8728dc4",
    "idDiaChinh": "DC05",
    "tenDiaChinh": "Bắc Kạn",
    "kinhTuyenTruc": "106.50",
    "stt": "5",
    "keyTimKiem": "BACKAN",
    "createdAt": "2021-12-12T14:54:02.920Z",
    "updatedAt": "2021-12-12T14:54:02.920Z"
  },
  {
    "id": "61b60d0352535959b8728de6",
    "idDiaChinh": "DC39",
    "tenDiaChinh": "Nam Định",
    "kinhTuyenTruc": "105.50",
    "stt": "39",
    "keyTimKiem": "NAMDINH",
    "createdAt": "2021-12-12T14:54:02.929Z",
    "updatedAt": "2021-12-12T14:54:02.929Z"
  },
  {
    "id": "61b60d0352535959b8728ddf",
    "idDiaChinh": "DC32",
    "tenDiaChinh": "Kiên Giang",
    "kinhTuyenTruc": "104.50",
    "stt": "32",
    "keyTimKiem": "KIENGIANG",
    "createdAt": "2021-12-12T14:54:02.927Z",
    "updatedAt": "2021-12-12T14:54:02.927Z"
  }
];
