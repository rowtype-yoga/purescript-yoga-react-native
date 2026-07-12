import React from "react";
import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { enableScreens } from "react-native-screens";

enableScreens(true);

const Stack = createNativeStackNavigator();
const routes = [
  "landing",
  "controls",
  "inputs",
  "uikit",
  "feedback",
  "data",
  "list",
  "platform",
  "springs",
];

export const iosNativeStackImpl = Content => {
  const screens = routes.map(name =>
    React.createElement(Stack.Screen, {
      key: name,
      name,
      options: {
        headerShown: false,
        gestureEnabled: name !== "landing" && name !== "springs",
        fullScreenGestureEnabled: name !== "landing" && name !== "springs",
        customAnimationOnGesture: name !== "springs",
      },
      children: ({ navigation }) =>
        React.createElement(Content, {
          page: name,
          navigate: destination => () => navigation.navigate(destination),
          goBack: () => navigation.goBack(),
        }),
    })
  );

  return React.createElement(
    NavigationContainer,
    null,
    React.createElement(
      Stack.Navigator,
      { initialRouteName: "landing" },
      screens
    )
  );
};
