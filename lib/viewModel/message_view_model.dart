import 'package:flutter/material.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/request_models/message_model.dart';
import 'package:petadoption/models/response_models/message_info.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/viewModel/admin_view_models/secureMeetup_admin_view_model.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/hive_models/user.dart';
import '../models/message.dart';
import '../models/request_models/delete_user.dart';
import '../models/request_models/receiver_model.dart';
import '../models/response_models/meetup.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import '../views/modals/meetup_modal.dart';

class MessageViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  GlobalService get _globalService => locator<GlobalService>();
  SecuremeetupAdminViewModel get _meetupModel =>
      locator<SecuremeetupAdminViewModel>();

  MessageModel? message;
  List<MessageModel>? messages;
  MessageInfo? messageinfo;
  List<MessageInfo>? messagesinfo;
  List<MessageInfo>? filteredMessage;
  User? user;
  bool intailized = false;
  Future<void> gotoMessage(MessageModel message) async {
    try {
      loading(true);
      // var res = await _apiService.getHealthByPetId(SinglePet(petId: pet.petId));

      // if (res.errorCode == "PA0004") {
      //   await _navigationService.pushModalBottom(Routes.health_modal,
      //       data: HealthInfoModal(
      //         info: res.data as PetHealthInfo,
      //       ));
      // } else {
      //   await _dialogService.showApiError(res.data);
      // }
    } catch (e, s) {
      _globalService.logError("Error Occured", e.toString(), s);
    } finally {
      loading(false);
    }
  }

  Future<void> getMessagesInfo() async {
    try {
      user = _globalService.getuser();
      if (user == null) {
        return;
      }
      String userId = user!.userId;
      //loading(true);
      var mesRes = await _apiService.getMessages(MessageInfo(userId: userId));

      if (mesRes.errorCode == "PA0004") {
        messagesinfo = (mesRes.data as List)
            .map((json) => MessageInfo.fromJson(json as Map<String, dynamic>))
            .toList();
        filteredMessage = List.from(messagesinfo!);
        intailized = true;
      } else {
        await _dialogService.showApiError(mesRes.data);
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured While Fetching Messages", e.toString(), s);
    } finally {
      notifyListeners();
      // loading(false);
    }
  }

  void filteredMessages(String pattern) {
    if (pattern.trim().isEmpty) {
      filteredMessage = List.from(messagesinfo ?? []);
    } else {
      filteredMessage = messagesinfo
          ?.where((u) => u.email!.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void resetFilter() {
    filteredMessage = List.from(messagesinfo ?? []);
    notifyListeners();
  }

  Future<void> gotoMessageInfo() async {
    await getMessagesInfo();
    await _navigationService.pushNamedAndRemoveUntil(
        args: TransitionType.slideRight, Routes.home);
  }

  ReceiverModel? reciverInfo;
  Future<void> getReceiverInfo(String userId) async {
    try {
      var userRes = await _apiService.getUserinfo(SingleUser(userId: userId));
      if (userRes.errorCode == "PA0004") {
        reciverInfo = userRes.data as ReceiverModel;
      } else {
        return;
      }
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
    }
  }

  Future<void> addmeetupModal() async {
    _navigationService.openModalBottomSheet(
        Routes.meetup_modal,
        MeetupModal(
          adopterId: reciverInfo!.userId,
          userId: user!.userId,
        ));
  }

  MessageInfo? currentInfo;
  String? receiverId;
  String? senderId;
  Future<void> gotoMessagePage(MessageInfo messageInfo) async {
    try {
      receiverId = messageInfo.userId;
      user ??= _globalService.getuser();
      if (user == null) return;
      senderId = user!.userId;
      currentInfo = messageInfo;
      await getReceiverInfo(receiverId!);
      bool mes = await getMessages(messageInfo.userId);
      if (!mes) {
        return;
      }
      await _navigationService.pushNamedAndRemoveUntil(
          args: TransitionType.slideRight, Routes.message);
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
    }
  }

  Future<void> deleteMessage(MessageModel message) async {
    try {
      loading(true, loadingText: "Deleting Message");
      if (user != null && message.senderId != user!.userId) {
        loading(false);
        return;
      }
      bool res = await _dialogService.showAlertDialog(
          Message(description: "Do you Really want to deleteMessage ?"));
      if (res) {
        var resDelete = await _apiService.deleteMessage(message);
        if (resDelete.errorCode == "PA0004") {
          _dialogService.showSuccess(text: "Deleted Message SuccessFully");
        } else {
          await _dialogService.showApiError(resDelete.data);
        }
      }
    } catch (e) {
      loading(false);
      debugPrint("Error => $e");
    } finally {
      await getMessages(message.receiverId ?? "");
      notifyListeners();
      loading(false);
    }
  }

  void updateMessage(MessageModel message) async {
    try {
      if (user != null && message.senderId != user!.userId) {
        return;
      }
      loading(true);
      var updatePetrRes = await _apiService.updateMessages(message);

      if (updatePetrRes.errorCode == "PA0004") {
        _dialogService.showSuccess(text: "Updated Message SuccessFully");
      } else {
        await _dialogService.showApiError(updatePetrRes.data);
      }
    } catch (e) {
      loading(false);
      debugPrint(e.toString());
    } finally {
      await getMessages(message.receiverId ?? "");
      notifyListeners();
      loading(false);
    }
  }

  Future<bool> getMessages(String receiverId) async {
    try {
      if (user == null) {
        return false;
      }
      String userId = user!.userId;
      //loading(true);
      var mesRes = await _apiService.getMessagesBetweenUsers(MessageModel(
        senderId: userId,
        receiverId: receiverId,
      ));

      if (mesRes.errorCode == "PA0004") {
        messages = (mesRes.data as List)
            .map((json) => MessageModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return true;
      } else {
        await _dialogService.showApiError(mesRes.data);
        return false;
      }
    } catch (e, s) {
      _globalService.logError(
          "Error Occured While Fetching Messages", e.toString(), s);
      return false;
    } finally {
      notifyListeners();

      // loading(false);
    }
  }

  Future<void> addMessage(
      String senderId, String receiverId, String content) async {
    try {
      var addRes = await _apiService.addMessage(MessageModel(
          senderId: senderId, receiverId: receiverId, content: content));
      if (addRes.errorCode == "PA0004") {
      } else {
        await _dialogService.showApiError(addRes.data);
      }
    } catch (e) {
      loading(false);
      debugPrint(e.toString());
    } finally {
      loading(false);
    }
  }

  MessageModel? selectedMessage;

  void selectMessage(MessageModel? message) {
    selectedMessage = message;

    notifyListeners();
  }

  IO.Socket? socket;

  void initSocket(String userId, String receiverId) async {
    try {
      if (socket != null && socket!.connected) {
        return; // Prevent reinitialization
      }
      String url = await _globalService.getHost();
      socket = IO.io(url, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket!.connect();

      socket!.onConnect((_) {
        //debugPrint('Connected to Socket.IO server');
        socket!
            .emit('joinRoom', {'senderId': userId, 'receiverId': receiverId});
      });

      socket!.off(
          'receiveMessage'); // REMOVE previous listener to avoid duplicates
      socket!.on('receiveMessage', (data) {
        //debugPrint('receiveMessage: $data');
        final newMsg = MessageModel.fromJson(data);
        messages!.add(newMsg);
        notifyListeners();
      });
      socket!.on('updateMessage', (data) {
        final updtMsg = MessageModel.fromJson(data);

        for (int i = 0; i < messages!.length; i++) {
          if (messages![i].messageId == updtMsg.messageId) {
            messages![i] = updtMsg;
            break;
          }
        }
        notifyListeners();
      });

      socket!.on('deleteMessage', (data) {
        //debugPrint('❌ Message deleted: $data');
        final delMsg = MessageModel.fromJson(data);

        messages?.removeWhere((msg) => msg.messageId == delMsg.messageId);

        // Optionally update UI
        notifyListeners(); // if using StatefulWidget
      });

      socket!.onDisconnect((_) => debugPrint('Disconnected from server'));
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
    }
  }

  void sendMessage(MessageModel msg) async {
    try {
      socket?.emit('sendMessage', msg.toJson());
      debugPrint("Sending message: ${msg.toJson()}");

      notifyListeners();
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
    }
  }

  void disposeSocket() {
    socket?.disconnect();
    socket?.destroy();
    socket = null;
  }

  List<String> listItems = [];

  void onMenuItemTap(String item) {
    switch (item.toLowerCase()) {
      case "add meetup":
        addmeetupModal();
        break;
      case "update meetup":
        addmeetupModal();
        break;
      // future options can go here
    }
  }

  Future<void> drawerLogic() async {
    try {
      _meetupModel.setisUpdate(false);
      if (user == null) return;
      listItems = [];
      if (user!.role!.toLowerCase() == "donor") {
        await addDonorActions();
        if (meets == null) {
          listItems.add("Add Meetup");
        } else {
          listItems.add("Update Meetup");
        }
      }
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
    } finally {
      loading(false);
      notifyListeners();
    }
  }

  Meetup? meets;
  Future<void> addDonorActions() async {
    try {
      loading(true, loadingText: "Getting Events ....");
      var res = await _apiService.getMeetupsBetweenUserId(Meetup(
          userId: _globalService.getuser()!.userId, receiverId: receiverId));
      if (res.errorCode == "PA0004") {
        meets = res.data;
        _meetupModel.setData(meets!);
        // _meetupModel.setisUpdate(true);
      }
    } catch (e) {
      loading(false);
    }
  }
}
