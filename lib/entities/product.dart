class Food{
  String title;
  DateTime expirationDate;
  late DateTime afterOpenedDate;
  bool open = false;

  Food(this.title,this.expirationDate);

  DateTime getExpirationDate(){
    return this.expirationDate;
  }

  bool isOpen(){
    return open;
  }

  setOpen(bool open){
    this.open = open;
  }
}