String convertRoleUser(String role) {
  switch (role) {
    case 'USER':
      return "Người dùng";
      break;
    case 'COMPANY':
      return "Người dùng";
      break;
    case 'AGENT':
      return "Nhà môi giới";
      break;
    case 'ADMIN':
      return "Người quản lý";
      break;
    case 'ADMIN_POST':
      return "Người dùng";
      break;
    case 'ADMIN_USER':
      return "Người quản lý";
      break;
    case 'MOD':
      return "Người dùng";
      break;
    case 'MANAGER':
      return "Quản lý";
      break;

    default:
      return "Người dùng";
  }
}
