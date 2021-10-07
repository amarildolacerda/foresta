// @dart=2.12
import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';

class DrawerMenuUser {
  final String? userName;
  final String? userEmail;
  final Widget? avatar;
  final String? avatarUrl;
  final Widget? background;
  final String? backgroundUrl;
  final Widget? userHeader;
  DrawerMenuUser(
      {this.userName,
      this.userEmail,
      this.avatar,
      this.avatarUrl,
      this.background,
      this.backgroundUrl,
      this.userHeader});
}

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    Key? key,
    this.user,
    required this.choices,
    this.top = 10,
    this.topNavigator,
    this.bottomNavigator,
  }) : super(key: key);
  final double top;
  final DrawerMenuUser? user;
  final List<TabChoice> choices;
  final Widget? topNavigator;
  final Widget? bottomNavigator;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (topNavigator != null) topNavigator!,
        Expanded(
            child: ListView(
          children: [
            if (user != null)
              (user!.userHeader != null)
                  ? user!.userHeader!
                  : DrawerUserHeader(
                      name: Text(user!.userName ?? ''),
                      email: Text(user!.userEmail ?? ''),
                      avatar: user!.avatar == null
                          ? null
                          : CircleAvatar(
                              child: ClipOval(
                              child: user!.avatar ??
                                  (user!.avatarUrl == null
                                      ? null
                                      : Image.network(
                                          user!.avatarUrl!,
                                          fit: BoxFit.cover,
                                          width: 90,
                                          height: 90,
                                        )),
                            )),
                      background: user!.background ??
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                image: (user!.backgroundUrl == null)
                                    ? null
                                    : DecorationImage(
                                        fit: BoxFit.fill,
                                        image:
                                            NetworkImage(user!.backgroundUrl!),
                                      )),
                          )),
            SizedBox(height: top),
            for (var item in choices) _createItem(context, item),
          ],
        )),
        if (bottomNavigator != null) bottomNavigator!,
      ],
    );
  }

  _createItem(BuildContext context, TabChoice item) {
    return DrawerMenuTile(
        title: item.label!,
        items: item.items,
        image: item.image,
        enabled: item.enabled,
        style: item.style,
        tooltip: item.tooltip,
        onPressed: () {
          if (item.onPressed != null) item.onPressed!();
        });
  }
}

class DrawerUserHeader extends StatelessWidget {
  const DrawerUserHeader(
      {Key? key, this.name, this.email, this.avatar, this.background})
      : super(key: key);
  final Widget? name;
  final Widget? email;
  final Widget? avatar;
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: const TextStyle(color: Colors.white60),
        child: SizedBox(
            height: 100,
            child: Stack(children: [
              if (background != null) background!,
              if (avatar != null) Positioned(top: 10, left: 10, child: avatar!),
              if (name != null) Positioned(top: 60, left: 10, child: name!),
              if (email != null) Positioned(top: 75, left: 10, child: email!),
            ])));
  }
}

class DrawerMenuTile extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;

  final Widget? image;
  final String? title;
  final Widget? subtitle;
  final bool enabled;
  final Function()? onPressed;
  final double? height;
  final double? fontSize;
  final List<TabChoice>? items;
  final TextStyle? style;
  final String? tooltip;
  final EdgeInsets? padding;

  DrawerMenuTile(
      {this.image,
      @required this.title,
      this.onPressed,
      this.leading,
      this.trailing,
      this.height: 40,
      this.enabled = true,
      this.fontSize = 16,
      this.subtitle,
      this.style,
      this.tooltip,
      this.padding,
      this.items});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color _color = (enabled)
        ? (style != null)
            ? style!.color!
            : theme.textTheme.bodyText2!.color!
        : theme.dividerColor;

    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 8),
      height: height,
      child: InkWell(
        child: Row(children: [
          if (leading != null) leading!,
          if (image != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: image!,
            ),
          if (items == null)
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) createLabel(theme, _color, title!),
                  ]),
            ),
          if (items != null) ...[
            Expanded(
              child: PopupMenuButton<TabChoice>(
                  tooltip: tooltip,
                  offset: Offset(0, 30),
                  child: createLabel(theme, _color, title!),
                  //icon: image,
                  itemBuilder: (ctx) {
                    return [
                      for (var it in items!)
                        PopupMenuItem(
                          textStyle: theme.textTheme.bodyText1!,
                          value: it,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (it.image != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: it.image!,
                                ),
                              Expanded(
                                child: (it.items == null)
                                    ? createLabel(theme, _color, it.label!)
                                    : DefaultTextStyle(
                                        style: theme.textTheme.bodyText1!,
                                        child: DrawerMenuTile(
                                          padding: EdgeInsets.zero,
                                          style: theme.textTheme.bodyText1,
                                          title: it.label,
                                          items: it.items,
                                          enabled: it.enabled,
                                          onPressed: () {
                                            if (it.onPressed != null)
                                              it.onPressed!();
                                          },
                                          image: it.image,
                                        )),
                              ),
                            ],
                          ),
                        )
                    ];
                  },
                  onSelected: (TabChoice x) {
                    if (x.onPressed != null) x.onPressed!();
                  }),
            ),
            trailing ?? Icon(Icons.chevron_right, color: _color)
          ]
        ]),
        onTap: (!enabled)
            ? null
            : () {
                if (onPressed != null) onPressed!();
              },
      ),
    );
  }

  createLabel(ThemeData theme, Color color, String texto) {
    return Container(
      alignment: Alignment.centerLeft,
      height: height! * .90,
      child: Text(
        title!,
        overflow: TextOverflow.ellipsis,
        style: style ??
            theme.textTheme.caption!.copyWith(
              fontSize: fontSize!,
              color: color,
            ),
      ),
    );
  }
}
