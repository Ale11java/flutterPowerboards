import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../timu_api/timu_api.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({required this.profile, required this.size, super.key});

  final TimuObject profile;
  final double size;

  @override
  Widget build(BuildContext context) {
    ImageProvider? avatar;
    final String initials =
        '${(profile.rawData['firstName'] ?? "").toString().characters.first}${(profile.rawData['lastName'] ?? "").toString().characters.first}';

    final Widget avatarInitials = Text(initials,
        style: GoogleFonts.inter(textStyle: const TextStyle(fontSize: 14)));

    final attachments = profile.getAttachments();
    final avatarAttachment = attachments.firstWhere(
        (element) => element.name == 'avatar.png',
        orElse: () => missingAttachment);

    if (avatarAttachment != missingAttachment) {
      avatar = NetworkImage(avatarAttachment.url);
    }

    return CircleAvatar(
      backgroundImage: avatar,
      radius: size / 2,
      child: avatar == null ? avatarInitials : null,
    );
  }
}
