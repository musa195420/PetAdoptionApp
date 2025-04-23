import 'package:flutter/material.dart';
import 'package:petadoption/models/selection_box_model.dart';
import 'package:provider/provider.dart';
import 'package:petadoption/viewModel/admin_view_models/admin_view_model.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminViewModel>();
    final List<Widget> listItems = [];

    for (final box in viewModel.boxes) {
      listItems.add(_buildMainBox(box, viewModel));
      if (viewModel.expandedBoxId == box.id) {
        final subItems = viewModel.subItemsMap[box.id] ?? [];
        for (final sub in subItems) {
          listItems.add(_buildSubItem(sub, viewModel));
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/images/bg.png')),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      viewModel.logout();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:Color(0xFF5D1F00),
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    "Admin Dashboard  ",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D1F00),
                    ),
                  ),
                ),
              ],
            ),
             const SizedBox(height: 20),
            Divider(color:  Color(0xFF5D1F00),thickness: 2,),
           
            Expanded(
              child: ListView(
                children: listItems,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainBox(SelectionBox box, AdminViewModel viewModel) {
    final isExpanded = viewModel.expandedBoxId == box.id;

    return GestureDetector(
      onTap: () => viewModel.toggleBox(box.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: isExpanded
              ? const LinearGradient(
                  colors: [Color(0xFF3D1B00), Color(0xFFFF7700)],
                )
              : LinearGradient(
                  colors: [Colors.grey, Colors.grey.shade400],
                ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Image.asset(box.image, fit: BoxFit.contain),
            ),
            Expanded(
              child: Text(
                box.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSubItem(String label, AdminViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.onSubItemTapped(label),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: Border.all(color: Color(0xFF5D1F00), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5D1F00),
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 30,
              color: Colors.brown,
            )
          ],
        ),
      ),
    );
  }
}
