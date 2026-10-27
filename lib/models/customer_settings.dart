class CustomerSettings {
  final String address;
  final String email;
  final String patronNo;
  final bool receiveNews;

  const CustomerSettings(
      {this.address = '',
      this.email = '',
      this.patronNo = '',
      this.receiveNews = false});
}
