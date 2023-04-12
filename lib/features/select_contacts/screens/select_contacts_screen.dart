import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/select_contacts_controller.dart';
import 'package:whatsapp_clone/widgets/error.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = "/select-contact";
  const SelectContactScreen({super.key});

  void selectContact(WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref.read(selectContactProvider).selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contact"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                print(contact.photo);
                return InkWell(
                  onTap: () => selectContact(ref, contact, context),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      leading: contact.photo == null
                          ? const CircleAvatar(
                              backgroundImage: NetworkImage("https://st3.depositphotos.com/6672868/13701/v/600/depositphotos_137014128-stock-illustration-user-profile-icon.jpg"),
                            )
                          : CircleAvatar(
                              backgroundImage: MemoryImage(contact.photo!),
                              radius: 30,
                            ),
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      // subtitle: ,
                    ),
                  ),
                );
              },
            ),
            error: ((error, stackTrace) => ErrorScreen(
                  error: error.toString(),
                )),
            loading: () => const Loader(),
          ),
    );
  }
}
