class PlanningData {
  ThongTinChung? thongTinChung;
  int? blocked;

  PlanningData({this.thongTinChung, this.blocked});

  PlanningData.fromJson(Map<String, dynamic> json) {
    thongTinChung = json['ThongTinChung'] != null
        ? new ThongTinChung.fromJson(json['ThongTinChung'])
        : null;
    blocked = json['blocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.thongTinChung != null) {
      data['ThongTinChung'] = this.thongTinChung!.toJson();
    }
    data['blocked'] = this.blocked;
    return data;
  }
}

class ThongTinChung {
  String? dientich;
  String? sothua;
  List<Dsttdoan>? dsttdoan;
  String? soto;
  String? mathuadat;
  String? ranh;
  List<String>? dsdoan;
  String? tenquanhuyen;
  String? tenphuongxa;
  String? marker;

  ThongTinChung(
      {this.dientich,
      this.sothua,
      this.dsttdoan,
      this.soto,
      this.mathuadat,
      this.ranh,
      this.dsdoan,
      this.tenquanhuyen,
      this.tenphuongxa,
      this.marker});

  ThongTinChung.fromJson(Map<String, dynamic> json) {
    dientich = json['dientich'];
    sothua = json['sothua'];
    if (json['dsttdoan'] != null) {
      dsttdoan = <Dsttdoan>[];
      json['dsttdoan'].forEach((v) {
        dsttdoan!.add(new Dsttdoan.fromJson(v));
      });
    }
    soto = json['soto'];
    mathuadat = json['mathuadat'];
    ranh = json['ranh'];
    dsdoan = json['dsdoan'].cast<String>();
    tenquanhuyen = json['tenquanhuyen'];
    tenphuongxa = json['tenphuongxa'];
    marker = json['marker'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dientich'] = this.dientich;
    data['sothua'] = this.sothua;
    if (this.dsttdoan != null) {
      data['dsttdoan'] = this.dsttdoan!.map((v) => v.toJson()).toList();
    }
    data['soto'] = this.soto;
    data['mathuadat'] = this.mathuadat;
    data['ranh'] = this.ranh;
    data['dsdoan'] = this.dsdoan;
    data['tenquanhuyen'] = this.tenquanhuyen;
    data['tenphuongxa'] = this.tenphuongxa;
    data['marker'] = this.marker;
    return data;
  }
}

class Dsttdoan {
  String? qhpkranhGeom;
  String? coquanpd;
  String? tendoan;
  int? gidqhpkranh;
  String? qhpkranhStt;
  String? ngayduyet;
  String? maqhpkranh;
  String? qhpkranhMaqh;
  String? soqd;
  String? maqhpkranhNew;

  Dsttdoan(
      {this.qhpkranhGeom,
      this.coquanpd,
      this.tendoan,
      this.gidqhpkranh,
      this.qhpkranhStt,
      this.ngayduyet,
      this.maqhpkranh,
      this.qhpkranhMaqh,
      this.soqd,
      this.maqhpkranhNew});

  Dsttdoan.fromJson(Map<String, dynamic> json) {
    qhpkranhGeom = json['qhpkranh_geom'];
    coquanpd = json['coquanpd'];
    tendoan = json['tendoan'];
    gidqhpkranh = json['gidqhpkranh'];
    qhpkranhStt = json['qhpkranh_stt'];
    ngayduyet = json['ngayduyet'];
    maqhpkranh = json['maqhpkranh'];
    qhpkranhMaqh = json['qhpkranh_maqh'];
    soqd = json['soqd'];
    maqhpkranhNew = json['maqhpkranh_new'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qhpkranh_geom'] = this.qhpkranhGeom;
    data['coquanpd'] = this.coquanpd;
    data['tendoan'] = this.tendoan;
    data['gidqhpkranh'] = this.gidqhpkranh;
    data['qhpkranh_stt'] = this.qhpkranhStt;
    data['ngayduyet'] = this.ngayduyet;
    data['maqhpkranh'] = this.maqhpkranh;
    data['qhpkranh_maqh'] = this.qhpkranhMaqh;
    data['soqd'] = this.soqd;
    data['maqhpkranh_new'] = this.maqhpkranhNew;
    return data;
  }
}