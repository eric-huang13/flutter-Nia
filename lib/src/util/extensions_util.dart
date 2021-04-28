extension Extension on Object {
  bool isNullOrEmpty() => this == null || this == '';

  bool isNullEmptyOrFalse() => this == null || this == '' || !this;

  bool isNullEmptyZeroOrFalse() =>
      this == null || this == '' || !this || this == 0;

  bool isNullOrFalse() => this == null || !this;
}
