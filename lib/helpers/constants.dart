// ignore_for_file: constant_identifier_names

double height = 800;
double width = 400;

enum VerificationStatus { Applied, Rejected, Approved }

VerificationStatus? parseVerificationStatus(String? value) {
  switch (value) {
    case 'Applied':
      return VerificationStatus.Applied;
    case 'Rejected':
      return VerificationStatus.Rejected;
    case 'Approved':
      return VerificationStatus.Approved;
    default:
      return null;
  }
}

String? verificationStatusToString(VerificationStatus? status) {
  return status?.name;
}
