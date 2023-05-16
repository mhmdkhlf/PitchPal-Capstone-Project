import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/data/team.dart';
import '../components/response_dialog_box.dart';
import '../components/number_input_field.dart';
import '../components/submit_button.dart';
import '../components/textfield_input.dart';
import '../data/player.dart';
import '../constants.dart';

class CreateTeam extends StatefulWidget {
  const CreateTeam({
    super.key,
    required this.captain,
  });

  final Player captain;

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  final TextEditingController teamNameController = TextEditingController();
  final TextEditingController numberOfPlayersController =
      TextEditingController();

  final List<PlayerInput> playerInputs = [];
  int numberPlayers = 2;

  Future<void> createTeam() async {
    if (teamNameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const ResponseDialogBox(
          text: 'Team name cannot be empty',
        ),
      );
      return;
    }
    if (numberPlayers < 2) {
      showDialog(
        context: context,
        builder: (context) => const ResponseDialogBox(
          text: 'You have to add at least two players to the team',
        ),
      );
      return;
    }
    List<bool> doAllPlayerIdsHaveValidFormatList = [];
    for (PlayerInput playerInput in playerInputs) {
      doAllPlayerIdsHaveValidFormatList.add(playerInput.isIdInputFormatValid());
    }
    final bool doAllPlayerIdsHaveValidFormat =
        doAllPlayerIdsHaveValidFormatList.every((element) => element);
    if (!doAllPlayerIdsHaveValidFormat) {
      showDialog(
        context: context,
        builder: (context) => const ResponseDialogBox(
          text: 'Invalid player IDs format\n(should be like -> 000-000)',
        ),
      );
      return;
    }
    for (PlayerInput playerInput in playerInputs) {
      if (!(await playerInput.doesPlayerIdExist())) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => ResponseDialogBox(
              text: 'No player has the id: ${playerInput.playerIdInput.text}',
            ),
          );
        }
        return;
      }
    }
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }
    final Dio dio = Dio();
    final String teamName = teamNameController.text;
    final List<String> playerIds = [];
    for (PlayerInput playerInput in playerInputs) {
      playerIds.add(playerInput.playerIdInput.text);
    }
    final Team team = Team.createProfile(
      name: teamName,
      captainId: widget.captain.playerID!,
      playerIds: playerIds,
    );
    try {
      final response = await dio.post(
        '$apiRoute/newTeam',
        data: team.toJsonMap(),
      );
      if (response.statusCode != 200) {
        throw Exception("Invalid status code team post");
      }
    } on DioError catch (e) {
      throw Exception(e.stackTrace);
    }
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => const ResponseDialogBox(
          text: 'You successfully created a team',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Create a new Team',
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                TextFieldInput(
                  controller: teamNameController,
                  hintText: 'Team Name',
                ),
                const SizedBox(height: 25),
                Text(
                  'Captain ID#: ${widget.captain.playerID} (you)',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Number of Players',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: NumberInputField(
                          controller: numberOfPlayersController,
                          hintText: "?   ",
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => setState(() {
                          numberPlayers =
                              int.tryParse(numberOfPlayersController.text) ?? 2;
                        }),
                        child: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: numberPlayers,
                  itemBuilder: (context, index) {
                    if (playerInputs.isEmpty) {
                      for (int i = 0; i < numberPlayers; i++) {
                        playerInputs.add(PlayerInput());
                      }
                    } else {
                      int diff = playerInputs.length - numberPlayers;
                      if (diff > 0) {
                        for (int i = 0; i < diff; i++) {
                          playerInputs.removeLast();
                        }
                      } else {
                        int old = playerInputs.length;
                        for (int i = old; i < numberPlayers; i++) {
                          playerInputs.add(PlayerInput());
                        }
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          TextFieldInput(
                            controller: playerInputs[index].playerIdInput,
                            hintText: "ID of Player #${index + 1}",
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                SubmitButton(
                  text: 'Submit',
                  onTap: createTeam,
                  fontSize: 20,
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerInput {
  final TextEditingController playerIdInput = TextEditingController();

  bool isIdInputFormatValid() {
    final String input = playerIdInput.text;
    return input.length == 7 &&
        int.tryParse(input.substring(0, 3)) != null &&
        int.tryParse(input.substring(4, 7)) != null &&
        input[3] == '-';
  }

  Future<bool> doesPlayerIdExist() async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(
        '$apiRoute/getPlayer/${playerIdInput.text}',
      );
      return response.data != null;
    } on DioError catch (e) {
      throw Exception(e.stackTrace);
    }
  }
}
