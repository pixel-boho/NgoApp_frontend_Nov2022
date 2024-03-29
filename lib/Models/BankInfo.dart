//
//
// class BankInfo {
//   String _aDDRESS;
//   String _bANK;
//   String _bANKCODE;
//   String _bRANCH;
//   String _cENTRE;
//   String _cITY;
//   String _cONTACT;
//   String _dISTRICT;
//   String _iFSC;
//   bool _iMPS;
//   String _mICR;
//   bool _nEFT;
//   bool _rTGS;
//   String _sTATE;
//   String _sWIFT;
//   bool _uPI;


//
//   BankInfo(
//       {String aDDRESS,
//         String bANK,
//         String bANKCODE,
//         String bRANCH,
//         String cENTRE,
//         String cITY,
//         String cONTACT,
//         String dISTRICT,
//         String iFSC,
//         bool iMPS,
//         String mICR,
//         bool nEFT,
//         bool rTGS,
//         String sTATE,
//         String sWIFT,
//         bool uPI}) {
//     this._aDDRESS = aDDRESS;
//     this._bANK = bANK;
//     this._bANKCODE = bANKCODE;
//     this._bRANCH = bRANCH;
//     this._cENTRE = cENTRE;
//     this._cITY = cITY;
//     this._cONTACT = cONTACT;
//     this._dISTRICT = dISTRICT;
//     this._iFSC = iFSC;
//     this._iMPS = iMPS;
//     this._mICR = mICR;
//     this._nEFT = nEFT;
//     this._rTGS = rTGS;
//     this._sTATE = sTATE;
//     this._sWIFT = sWIFT;
//     this._uPI = uPI;
//   }
//
//   String get aDDRESS => _aDDRESS;
//   set aDDRESS(String aDDRESS) => _aDDRESS = aDDRESS;
//   String get bANK => _bANK;
//   set bANK(String bANK) => _bANK = bANK;
//   String get bANKCODE => _bANKCODE;
//   set bANKCODE(String bANKCODE) => _bANKCODE = bANKCODE;
//   String get bRANCH => _bRANCH;
//   set bRANCH(String bRANCH) => _bRANCH = bRANCH;
//   String get cENTRE => _cENTRE;
//   set cENTRE(String cENTRE) => _cENTRE = cENTRE;
//   String get cITY => _cITY;
//   set cITY(String cITY) => _cITY = cITY;
//   String get cONTACT => _cONTACT;
//   set cONTACT(String cONTACT) => _cONTACT = cONTACT;
//   String get dISTRICT => _dISTRICT;
//   set dISTRICT(String dISTRICT) => _dISTRICT = dISTRICT;
//   String get iFSC => _iFSC;
//   set iFSC(String iFSC) => _iFSC = iFSC;
//   bool get iMPS => _iMPS;
//   set iMPS(bool iMPS) => _iMPS = iMPS;
//   String get mICR => _mICR;
//   set mICR(String mICR) => _mICR = mICR;
//   bool get nEFT => _nEFT;
//   set nEFT(bool nEFT) => _nEFT = nEFT;
//   bool get rTGS => _rTGS;
//   set rTGS(bool rTGS) => _rTGS = rTGS;
//   String get sTATE => _sTATE;
//   set sTATE(String sTATE) => _sTATE = sTATE;
//   String get sWIFT => _sWIFT;
//   set sWIFT(String sWIFT) => _sWIFT = sWIFT;
//   bool get uPI => _uPI;
//   set uPI(bool uPI) => _uPI = uPI;
//
//   BankInfo.fromJson(Map<String, dynamic> json) {
//     _aDDRESS = json['ADDRESS'];
//     _bANK = json['BANK'];
//     _bANKCODE = json['BANKCODE'];
//     _bRANCH = json['BRANCH'];
//     _cENTRE = json['CENTRE'];
//     _cITY = json['CITY'];
//     _cONTACT = json['CONTACT'];
//     _dISTRICT = json['DISTRICT'];
//     _iFSC = json['IFSC'];
//     _iMPS = json['IMPS'];
//     _mICR = json['MICR'];
//     _nEFT = json['NEFT'];
//     _rTGS = json['RTGS'];
//     _sTATE = json['STATE'];
//     _sWIFT = json['SWIFT'];
//     _uPI = json['UPI'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ADDRESS'] = this._aDDRESS;
//     data['BANK'] = this._bANK;
//     data['BANKCODE'] = this._bANKCODE;
//     data['BRANCH'] = this._bRANCH;
//     data['CENTRE'] = this._cENTRE;
//     data['CITY'] = this._cITY;
//     data['CONTACT'] = this._cONTACT;
//     data['DISTRICT'] = this._dISTRICT;
//     data['IFSC'] = this._iFSC;
//     data['IMPS'] = this._iMPS;
//     data['MICR'] = this._mICR;
//     data['NEFT'] = this._nEFT;
//     data['RTGS'] = this._rTGS;
//     data['STATE'] = this._sTATE;
//     data['SWIFT'] = this._sWIFT;
//     data['UPI'] = this._uPI;
//     return data;
//   }
// }
//
// class BankInfoTest {
//   bool nEFT;
//   bool uPI;
//   String sWIFT;
//   String bANKCODE;
//   String bANK;
//   String iFSC;
//   int mICR;
//   String bRANCH;
//   String aDDRESS;
//   String cITY;
//   String cENTRE;
//   String dISTRICT;
//   String sTATE;
//   int sTDCODE;
//   int cONTACT;
//
//   BankInfoTest(
//       {this.nEFT,
//         this.uPI,
//         this.sWIFT,
//         this.bANKCODE,
//         this.bANK,
//         this.iFSC,
//         this.mICR,
//         this.bRANCH,
//         this.aDDRESS,
//         this.cITY,
//         this.cENTRE,
//         this.dISTRICT,
//         this.sTATE,
//         this.sTDCODE,
//         this.cONTACT});
//
//   BankInfoTest.fromJson(Map<String, dynamic> json) {
//     nEFT = json['NEFT'];
//     uPI = json['UPI'];
//     sWIFT = json['SWIFT'];
//     bANKCODE = json['BANKCODE'];
//     bANK = json['BANK'];
//     iFSC = json['IFSC'];
//     mICR = json['MICR'];
//     bRANCH = json['BRANCH'];
//     aDDRESS = json['ADDRESS'];
//     cITY = json['CITY'];
//     cENTRE = json['CENTRE'];
//     dISTRICT = json['DISTRICT'];
//     sTATE = json['STATE'];
//     sTDCODE = json['STDCODE'];
//     cONTACT = json['CONTACT'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['NEFT'] = this.nEFT;
//     data['UPI'] = this.uPI;
//     data['SWIFT'] = this.sWIFT;
//     data['BANKCODE'] = this.bANKCODE;
//     data['BANK'] = this.bANK;
//     data['IFSC'] = this.iFSC;
//     data['MICR'] = this.mICR;
//     data['BRANCH'] = this.bRANCH;
//     data['ADDRESS'] = this.aDDRESS;
//     data['CITY'] = this.cITY;
//     data['CENTRE'] = this.cENTRE;
//     data['DISTRICT'] = this.dISTRICT;
//     data['STATE'] = this.sTATE;
//     data['STDCODE'] = this.sTDCODE;
//     data['CONTACT'] = this.cONTACT;
//     return data;
//   }
// }
class BankInfo {
  String mICR;
  String bRANCH;
  String aDDRESS;
  String sTATE;
  String cONTACT;
  bool uPI;
  bool rTGS;
  String cITY;
  String cENTRE;
  String dISTRICT;
  bool nEFT;
  bool iMPS;
  Null sWIFT;
  String iSO3166;
  String bANK;
  String bANKCODE;
  String iFSC;

  BankInfo(
      {this.mICR,
        this.bRANCH,
        this.aDDRESS,
        this.sTATE,
        this.cONTACT,
        this.uPI,
        this.rTGS,
        this.cITY,
        this.cENTRE,
        this.dISTRICT,
        this.nEFT,
        this.iMPS,
        this.sWIFT,
        this.iSO3166,
        this.bANK,
        this.bANKCODE,
        this.iFSC});

  BankInfo.fromJson(Map<String, dynamic> json) {
    mICR = json['MICR'];
    bRANCH = json['BRANCH'];
    aDDRESS = json['ADDRESS'];
    sTATE = json['STATE'];
    cONTACT = json['CONTACT'];
    uPI = json['UPI'];
    rTGS = json['RTGS'];
    cITY = json['CITY'];
    cENTRE = json['CENTRE'];
    dISTRICT = json['DISTRICT'];
    nEFT = json['NEFT'];
    iMPS = json['IMPS'];
    sWIFT = json['SWIFT'];
    iSO3166 = json['ISO3166'];
    bANK = json['BANK'];
    bANKCODE = json['BANKCODE'];
    iFSC = json['IFSC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MICR'] = this.mICR;
    data['BRANCH'] = this.bRANCH;
    data['ADDRESS'] = this.aDDRESS;
    data['STATE'] = this.sTATE;
    data['CONTACT'] = this.cONTACT;
    data['UPI'] = this.uPI;
    data['RTGS'] = this.rTGS;
    data['CITY'] = this.cITY;
    data['CENTRE'] = this.cENTRE;
    data['DISTRICT'] = this.dISTRICT;
    data['NEFT'] = this.nEFT;
    data['IMPS'] = this.iMPS;
    data['SWIFT'] = this.sWIFT;
    data['ISO3166'] = this.iSO3166;
    data['BANK'] = this.bANK;
    data['BANKCODE'] = this.bANKCODE;
    data['IFSC'] = this.iFSC;
    return data;
  }
}