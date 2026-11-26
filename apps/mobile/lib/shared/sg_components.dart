import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../core/theme/generated/sargoshi_tokens.g.dart';
import '../core/theme/performance_visuals.dart';
import 'sg_icon.dart';

extension SgBuildContext on BuildContext {
  SargoshiColors get sgColors =>
      Theme.of(this).extension<SargoshiColors>() ?? SargoshiColors.defaults;
}

// CMP-01 / CMP-02 / CMP-03
enum SgButtonVariant { primary, tonal, ghost, vault, dangerOutline }

class SgButton extends StatefulWidget {
  const SgButton({
    required this.label,
    required this.onPressed,
    this.variant = SgButtonVariant.primary,
    this.leading,
    this.trailing,
    this.isLoading = false,
    this.expand = false,
    this.semanticLabel,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final SgButtonVariant variant;
  final Widget? leading;
  final Widget? trailing;
  final bool isLoading;
  final bool expand;
  final String? semanticLabel;

  @override
  State<SgButton> createState() => _SgButtonState();
}

class _SgButtonState extends State<SgButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    final enabled = widget.onPressed != null && !widget.isLoading;
    final gradient = switch (widget.variant) {
      SgButtonVariant.primary => SargoshiColors.brandGradient,
      SgButtonVariant.vault => SargoshiColors.vaultGradient,
      _ => null,
    };
    final background = switch (widget.variant) {
      SgButtonVariant.tonal => colors.dusk2,
      SgButtonVariant.ghost || SgButtonVariant.dangerOutline =>
        Colors.transparent,
      SgButtonVariant.primary || SgButtonVariant.vault => null,
    };
    final foreground = widget.variant == SgButtonVariant.dangerOutline
        ? colors.coral
        : colors.moon;
    final borderColor = _focused
        ? colors.glow
        : widget.variant == SgButtonVariant.dangerOutline
            ? colors.coral
            : widget.variant == SgButtonVariant.ghost
                ? colors.line
                : Colors.transparent;

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel ?? widget.label,
      child: FocusableActionDetector(
        enabled: enabled,
        onShowFocusHighlight: (value) {
          if (_focused != value) setState(() => _focused = value);
        },
        child: AnimatedContainer(
          duration: SargoshiMotion.micro,
          decoration: BoxDecoration(
            color: enabled ? background : colors.dusk2,
            gradient: enabled && gradient != null
                ? LinearGradient(colors: gradient)
                : null,
            borderRadius: BorderRadius.circular(SargoshiShape.button),
            border: Border.all(
              color: borderColor,
              width: _focused ? SargoshiStroke.focus : SargoshiStroke.hairline,
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: enabled ? widget.onPressed : null,
              borderRadius: BorderRadius.circular(SargoshiShape.button),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: SargoshiComponents.buttonHeight,
                  minWidth: widget.expand ? double.infinity : 0,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SargoshiSpace.s20,
                    vertical: SargoshiSpace.s12,
                  ),
                  child: Row(
                    mainAxisSize:
                        widget.expand ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isLoading)
                        SizedBox(
                          width: SargoshiIconSize.standard,
                          height: SargoshiIconSize.standard,
                          child: CircularProgressIndicator(
                            strokeWidth: SargoshiStroke.ghost,
                            color: foreground,
                          ),
                        )
                      else if (widget.leading != null)
                        widget.leading!,
                      if (widget.isLoading || widget.leading != null)
                        const SizedBox(width: SargoshiSpace.s8),
                      Flexible(
                        child: Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: SargoshiType.label.copyWith(
                            color: foreground,
                          ),
                        ),
                      ),
                      if (widget.trailing != null) ...[
                        const SizedBox(width: SargoshiSpace.s8),
                        widget.trailing!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// CMP-04
class SgIconButton extends StatelessWidget {
  const SgIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.selected = false,
    this.filled = false,
    this.color,
    super.key,
  });

  final SgIconName icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool selected;
  final bool filled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      isSelected: selected,
      style: IconButton.styleFrom(
        minimumSize: Size(
          SargoshiBreakpoint.minInteractiveTarget,
          SargoshiBreakpoint.minInteractiveTarget,
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: filled || selected ? colors.dusk2 : Colors.transparent,
        foregroundColor: color ?? (selected ? colors.glow : colors.moon),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SargoshiShape.button),
        ),
      ),
      icon: SgIcon(icon, color: color ?? colors.moon),
      selectedIcon: SgIcon(icon, selected: true, color: color ?? colors.glow),
    );
  }
}

// CMP-05
class SgFab extends StatelessWidget {
  const SgFab({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.label,
    this.vault = false,
    super.key,
  });

  final SgIconName icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final String? label;
  final bool vault;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    final background = vault ? colors.vaultIndigo : colors.ember;
    if (label != null) {
      return FloatingActionButton.extended(
        heroTag: null,
        tooltip: tooltip,
        onPressed: onPressed,
        backgroundColor: background,
        foregroundColor: colors.paper,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SargoshiShape.fab),
        ),
        icon: SgIcon(icon, color: colors.paper),
        label: Text(label!),
      );
    }
    return FloatingActionButton(
      heroTag: null,
      tooltip: tooltip,
      onPressed: onPressed,
      backgroundColor: background,
      foregroundColor: colors.paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SargoshiShape.fab),
      ),
      child: SgIcon(icon, color: colors.paper),
    );
  }
}

// CMP-06
enum SgChipVariant { filter, assist, input, suggestion }

class SgChip extends StatelessWidget {
  const SgChip({
    required this.label,
    required this.variant,
    this.selected = false,
    this.onSelected,
    this.onDeleted,
    this.leading,
    super.key,
  });

  final String label;
  final SgChipVariant variant;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final VoidCallback? onDeleted;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    final chip = switch (variant) {
      SgChipVariant.filter => FilterChip(
          label: Text(label),
          selected: selected,
          showCheckmark: false,
          avatar: leading,
          onSelected: onSelected,
          visualDensity: VisualDensity.compact,
        ),
      SgChipVariant.assist || SgChipVariant.suggestion => ActionChip(
          label: Text(label),
          avatar: leading,
          onPressed: onSelected == null ? null : () => onSelected!(!selected),
          visualDensity: VisualDensity.compact,
        ),
      SgChipVariant.input => InputChip(
          label: Text(label),
          avatar: leading,
          selected: selected,
          onSelected: onSelected,
          onDeleted: onDeleted,
          visualDensity: VisualDensity.compact,
        ),
    };
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: SargoshiComponents.chipHeight,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          chipTheme: Theme.of(context).chipTheme.copyWith(
                backgroundColor: colors.dusk2,
                selectedColor: colors.ember.withValues(
                  alpha: SargoshiOpacity.pressedOverlay,
                ),
                side: BorderSide(color: colors.line),
                labelStyle: SargoshiType.label.copyWith(color: colors.moon),
                shape: const StadiumBorder(),
              ),
        ),
        child: chip,
      ),
    );
  }
}

// CMP-07
class SgSegmentedControl<T> extends StatelessWidget {
  const SgSegmentedControl({
    required this.values,
    required this.selected,
    required this.labelFor,
    required this.onSelectionChanged,
    super.key,
  }) : assert(values.length >= 2 && values.length <= 4);

  final List<T> values;
  final T selected;
  final String Function(T value) labelFor;
  final ValueChanged<T> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SargoshiComponents.segmentedHeight,
      child: SegmentedButton<T>(
        segments: values
            .map(
              (value) => ButtonSegment<T>(
                value: value,
                label: Text(labelFor(value)),
              ),
            )
            .toList(growable: false),
        selected: {selected},
        showSelectedIcon: false,
        onSelectionChanged: (selection) {
          if (selection.isNotEmpty) onSelectionChanged(selection.first);
        },
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(SargoshiType.label),
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}

// CMP-08
enum SgTextFieldVariant { filled, search, pin, passphrase }

class SgTextField extends StatefulWidget {
  const SgTextField({
    required this.label,
    this.controller,
    this.variant = SgTextFieldVariant.filled,
    this.hint,
    this.helper,
    this.error,
    this.onChanged,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.showVisibilityToggle = true,
    this.revealTooltip,
    this.concealTooltip,
    super.key,
  }) : assert(
          (variant != SgTextFieldVariant.pin &&
                  variant != SgTextFieldVariant.passphrase) ||
              !showVisibilityToggle ||
              (revealTooltip != null && concealTooltip != null),
        );

  final String label;
  final TextEditingController? controller;
  final SgTextFieldVariant variant;
  final String? hint;
  final String? helper;
  final String? error;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? maxLength;
  final int maxLines;
  final bool showVisibilityToggle;
  final String? revealTooltip;
  final String? concealTooltip;

  @override
  State<SgTextField> createState() => _SgTextFieldState();
}

class _SgTextFieldState extends State<SgTextField> {
  bool _obscure = true;

  bool get _isSecret =>
      widget.variant == SgTextFieldVariant.pin ||
      widget.variant == SgTextFieldVariant.passphrase;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    final isSearch = widget.variant == SgTextFieldVariant.search;
    final keyboardType = switch (widget.variant) {
      SgTextFieldVariant.pin => TextInputType.number,
      SgTextFieldVariant.passphrase => TextInputType.visiblePassword,
      SgTextFieldVariant.filled || SgTextFieldVariant.search =>
        TextInputType.text,
    };

    return TextField(
      controller: widget.controller,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      keyboardType: keyboardType,
      maxLines: _isSecret ? 1 : widget.maxLines,
      maxLength: widget.maxLength ??
          (widget.variant == SgTextFieldVariant.pin ? 8 : null),
      obscureText: _isSecret && _obscure,
      style: SargoshiType.body.copyWith(color: colors.moon),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.error == null ? widget.helper : null,
        errorText: widget.error,
        prefixIcon: isSearch
            ? const Padding(
                padding: EdgeInsets.all(SargoshiSpace.s12),
                child: SgIcon(SgIconName.search),
              )
            : null,
        prefixIconConstraints: isSearch
            ? const BoxConstraints(
                minWidth: SargoshiComponents.searchHeight,
                minHeight: SargoshiComponents.searchHeight,
              )
            : null,
        suffixIcon: widget.error != null
            ? Padding(
                padding: const EdgeInsets.all(SargoshiSpace.s12),
                child: SgIcon(
                  SgIconName.safetyWarning,
                  color: colors.coral,
                ),
              )
            : _isSecret && widget.showVisibilityToggle
                ? IconButton(
                    tooltip: _obscure ? widget.revealTooltip! : widget.concealTooltip!,
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: SgIcon(
                      _obscure ? SgIconName.hidden : SgIconName.visible,
                    ),
                  )
                : null,
      ),
    );
  }
}

// CMP-09
class SgToggle extends StatelessWidget {
  const SgToggle({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
    this.vault = false,
    super.key,
  });

  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool vault;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: SargoshiComponents.toggleHeight,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: SargoshiType.titleS),
        subtitle: Text(description, style: SargoshiType.caption),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: vault ? colors.vaultLilac : colors.mint,
          activeTrackColor: vault ? colors.vaultIndigo : colors.ember,
          inactiveTrackColor: colors.dusk3,
        ),
      ),
    );
  }
}

// CMP-10
class SgSlider extends StatelessWidget {
  const SgSlider({
    required this.value,
    required this.onChanged,
    required this.label,
    this.min = 0,
    this.max = 100,
    this.divisions,
    super.key,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final String label;
  final double min;
  final double max;
  final int? divisions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: SargoshiType.label),
            Text(value.round().toString(), style: SargoshiType.mono),
          ],
        ),
        Slider(
          value: value.clamp(min, max).toDouble(),
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// CMP-11
class SgCheckbox extends StatelessWidget {
  const SgCheckbox({
    required this.value,
    required this.onChanged,
    required this.title,
    this.description,
    super.key,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      subtitle: description == null ? null : Text(description!),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      minTileHeight: SargoshiBreakpoint.minInteractiveTarget,
    );
  }
}

class SgRadio<T> extends StatelessWidget {
  const SgRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.description,
    super.key,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Text(title),
      subtitle: description == null ? null : Text(description!),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      minTileHeight: SargoshiBreakpoint.minInteractiveTarget,
    );
  }
}

// CMP-12
enum SgAvatarShape { circle, roundedSquare }

class SgAvatar extends StatelessWidget {
  const SgAvatar({
    required this.initials,
    this.image,
    this.size = SargoshiComponents.avatarDefaultSize,
    this.shape = SgAvatarShape.circle,
    this.semanticLabel,
    super.key,
  });

  final String initials;
  final ImageProvider<Object>? image;
  final double size;
  final SgAvatarShape shape;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    final palette = [
      colors.dusk2,
      colors.vaultIndigo,
      colors.rose,
      colors.sky,
      colors.ember,
    ];
    final hash = initials.runes.fold<int>(0, (sum, rune) => sum + rune);
    final background = palette[hash % palette.length];
    final monogram = initials.runes
        .take(2)
        .map(String.fromCharCode)
        .join()
        .toUpperCase();
    final borderRadius = BorderRadius.circular(size * 0.28);

    final content = Container(
      width: size,
      height: size,
      color: background,
      alignment: Alignment.center,
      child: image == null
          ? Text(
              monogram,
              style: SargoshiType.label.copyWith(color: colors.paper),
              maxLines: 1,
            )
          : Image(
              image: image!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Text(
                monogram,
                style: SargoshiType.label.copyWith(color: colors.paper),
              ),
            ),
    );

    return Semantics(
      image: true,
      label: semanticLabel ?? initials,
      child: shape == SgAvatarShape.circle
          ? ClipOval(child: content)
          : ClipRRect(
              borderRadius: borderRadius,
              child: content,
            ),
    );
  }
}

// CMP-13
enum SgBadgeVariant { count, dot }

class SgBadge extends StatelessWidget {
  const SgBadge.count({
    required this.count,
    this.maxCount = 99,
    super.key,
  })  : variant = SgBadgeVariant.count,
        color = null;

  const SgBadge.dot({
    this.color,
    super.key,
  })  : count = 0,
        maxCount = 99,
        variant = SgBadgeVariant.dot;

  final int count;
  final int maxCount;
  final SgBadgeVariant variant;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    if (variant == SgBadgeVariant.dot) {
      return Container(
        width: SargoshiSpace.s8,
        height: SargoshiSpace.s8,
        decoration: BoxDecoration(
          color: color ?? colors.ember,
          shape: BoxShape.circle,
        ),
      );
    }
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      constraints: const BoxConstraints(
        minHeight: SargoshiComponents.badgeHeight,
        minWidth: SargoshiComponents.badgeHeight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: SargoshiSpace.s8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? colors.ember,
        borderRadius: BorderRadius.circular(SargoshiShape.chip),
      ),
      child: Text(
        count > maxCount ? '$maxCount+' : count.toString(),
        style: SargoshiType.caption.copyWith(
          color: colors.paper,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// CMP-14
class SgListTile extends StatelessWidget {
  const SgListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.lines = 1,
    super.key,
  }) : assert(lines >= 1 && lines <= 3);

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final int lines;

  @override
  Widget build(BuildContext context) {
    final height = switch (lines) {
      1 => SargoshiComponents.listTileOneLine,
      2 => SargoshiComponents.listTileTwoLine,
      _ => SargoshiComponents.listTileThreeLine,
    };
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: ListTile(
        onTap: onTap,
        leading: leading,
        title: Text(title, maxLines: lines, overflow: TextOverflow.ellipsis),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                maxLines: lines,
                overflow: TextOverflow.ellipsis,
              ),
        trailing: trailing,
        minTileHeight: height,
        contentPadding: const EdgeInsets.symmetric(horizontal: SargoshiSpace.s16),
      ),
    );
  }
}

// CMP-15
enum SgCardVariant { surface, outlined, alert }

class SgCard extends StatelessWidget {
  const SgCard({
    required this.child,
    this.variant = SgCardVariant.surface,
    this.alertColor,
    this.padding = const EdgeInsets.all(SargoshiSpace.s16),
    this.onTap,
    super.key,
  });

  final Widget child;
  final SgCardVariant variant;
  final Color? alertColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    final edge = alertColor ?? colors.ember;
    final visuals = Theme.of(context).extension<SargoshiPerformanceVisuals>();
    final glass = visuals?.enableGlass ?? false;
    final background =
        variant == SgCardVariant.surface ? colors.dusk : colors.dusk2;
    final borderRadius = BorderRadius.circular(SargoshiShape.card);

    final card = Material(
      color: background.withValues(alpha: glass ? 0.78 : 1),
      elevation: visuals?.enableSoftShadows == true
          ? visuals!.surfaceElevation
          : 0,
      shadowColor: colors.ink.withValues(alpha: SargoshiOpacity.focusedOverlay),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(
          color: variant == SgCardVariant.outlined
              ? colors.line
              : Colors.transparent,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (variant == SgCardVariant.alert)
              Container(
                width: SargoshiComponents.alertEdge,
                color: edge,
              ),
            Expanded(
              child: Padding(
                padding: padding,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );

    if (!glass || visuals == null || visuals.blurSigma <= 0) return card;
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: visuals.blurSigma,
          sigmaY: visuals.blurSigma,
        ),
        child: card,
      ),
    );
  }
}

// CMP-16
enum SgChatBubbleVariant { incoming, outgoing, whisper, system }

class SgChatBubble extends StatelessWidget {
  const SgChatBubble({
    required this.message,
    required this.timestamp,
    required this.variant,
    this.status,
    super.key,
  });

  final String message;
  final String timestamp;
  final SgChatBubbleVariant variant;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    final isOutgoing = variant == SgChatBubbleVariant.outgoing ||
        variant == SgChatBubbleVariant.whisper;
    final isSystem = variant == SgChatBubbleVariant.system;
    final background = switch (variant) {
      SgChatBubbleVariant.incoming => colors.dusk2,
      SgChatBubbleVariant.outgoing => colors.ember,
      SgChatBubbleVariant.whisper => colors.vaultIndigo,
      SgChatBubbleVariant.system => colors.ink,
    };
    final foreground = variant == SgChatBubbleVariant.outgoing
        ? colors.paper
        : isSystem
            ? colors.mist
            : colors.moon;

    return LayoutBuilder(
      builder: (context, viewport) {
        final availableWidth = viewport.maxWidth.isFinite
            ? viewport.maxWidth
            : SargoshiComponents.chatBubbleMaxWidth / 0.78;
        final bubbleWidth = math.min(
          SargoshiComponents.chatBubbleMaxWidth,
          availableWidth * 0.78,
        );

        return Align(
          alignment: isSystem
              ? Alignment.center
              : isOutgoing
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: bubbleWidth),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: SargoshiSpace.s4),
              padding: const EdgeInsets.symmetric(
                horizontal: SargoshiSpace.s16,
                vertical: SargoshiSpace.s12,
              ),
              decoration: BoxDecoration(
                color: variant == SgChatBubbleVariant.outgoing ? null : background,
                gradient: variant == SgChatBubbleVariant.outgoing
                    ? const LinearGradient(colors: SargoshiColors.brandGradient)
                    : null,
                borderRadius: BorderRadius.circular(SargoshiShape.bubble),
                border: variant == SgChatBubbleVariant.whisper
                    ? Border.all(color: colors.vaultLilac)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      message,
                      style: SargoshiType.message.copyWith(color: foreground),
                    ),
                  ),
                  const SizedBox(height: SargoshiSpace.s4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timestamp,
                        style: SargoshiType.caption.copyWith(color: colors.mist),
                      ),
                      if (status != null) ...[
                        const SizedBox(width: SargoshiSpace.s8),
                        Text(
                          status!,
                          style: SargoshiType.caption.copyWith(color: colors.mist),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// CMP-17
class SgRuleBadge extends StatelessWidget {
  const SgRuleBadge({
    required this.label,
    required this.icon,
    super.key,
  });

  final String label;
  final SgIconName icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SargoshiSpace.s8,
        vertical: SargoshiSpace.s4,
      ),
      decoration: BoxDecoration(
        color: colors.amber.withValues(alpha: SargoshiOpacity.pressedOverlay),
        borderRadius: BorderRadius.circular(SargoshiShape.chip),
        border: Border.all(color: colors.amber),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SgIcon(
            icon,
            size: SargoshiComponents.ruleIcon,
            color: colors.amber,
          ),
          const SizedBox(width: SargoshiSpace.s4),
          Text(
            label,
            style: SargoshiType.caption.copyWith(color: colors.amber),
          ),
        ],
      ),
    );
  }
}

// CMP-18
class SgReaction {
  const SgReaction({
    required this.emoji,
    required this.count,
    this.selected = false,
  });

  final String emoji;
  final int count;
  final bool selected;
}

class SgReactionBar extends StatelessWidget {
  const SgReactionBar({
    required this.reactions,
    required this.onReaction,
    super.key,
  });

  final List<SgReaction> reactions;
  final ValueChanged<String> onReaction;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    return SizedBox(
      height: SargoshiComponents.reactionBarHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: reactions
              .map(
                (reaction) => Padding(
                  padding: const EdgeInsetsDirectional.only(
                    end: SargoshiSpace.s8,
                  ),
                  child: Material(
                    color: reaction.selected ? colors.dusk3 : colors.dusk2,
                    borderRadius: BorderRadius.circular(SargoshiShape.chip),
                    child: InkWell(
                      onTap: () => onReaction(reaction.emoji),
                      borderRadius: BorderRadius.circular(SargoshiShape.chip),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SargoshiSpace.s12,
                          vertical: SargoshiSpace.s8,
                        ),
                        child: Text(
                          reaction.emoji + ' ' + reaction.count.toString(),
                          style: SargoshiType.label,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}

// CMP-19
class SgComposer extends StatefulWidget {
  const SgComposer({
    required this.onSend,
    required this.sendTooltip,
    this.controller,
    this.hint = '',
    this.onAttach,
    this.onVoice,
    this.attachTooltip,
    this.voiceTooltip,
    this.enabled = true,
    super.key,
  }) : assert(onAttach == null || attachTooltip != null),
       assert(onVoice == null || voiceTooltip != null);

  final ValueChanged<String> onSend;
  final TextEditingController? controller;
  final String hint;
  final VoidCallback? onAttach;
  final VoidCallback? onVoice;
  final String? attachTooltip;
  final String? voiceTooltip;
  final String sendTooltip;
  final bool enabled;

  @override
  State<SgComposer> createState() => _SgComposerState();
}

class _SgComposerState extends State<SgComposer> {
  late TextEditingController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _attachController(widget.controller);
  }

  void _attachController(TextEditingController? controller) {
    _ownsController = controller == null;
    _controller = controller ?? TextEditingController();
  }

  @override
  void didUpdateWidget(covariant SgComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) _controller.dispose();
      _attachController(widget.controller);
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _send() {
    final value = _controller.text.trim();
    if (!widget.enabled || value.isEmpty) return;
    widget.onSend(value);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    return Container(
      constraints: const BoxConstraints(
        minHeight: SargoshiComponents.composerMinHeight,
      ),
      padding: const EdgeInsets.all(SargoshiSpace.s8),
      decoration: BoxDecoration(
        color: colors.dusk,
        borderRadius: BorderRadius.circular(SargoshiShape.sheet),
        border: Border.all(color: colors.line),
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (context, value, _) => Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.onAttach != null)
              SgIconButton(
                icon: SgIconName.attach,
                tooltip: widget.attachTooltip!,
                onPressed: widget.enabled ? widget.onAttach : null,
              ),
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: widget.enabled,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  filled: false,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: SargoshiSpace.s8,
                    vertical: SargoshiSpace.s12,
                  ),
                ),
              ),
            ),
            if (widget.onVoice != null && value.text.trim().isEmpty)
              SgIconButton(
                icon: SgIconName.voice,
                tooltip: widget.voiceTooltip!,
                onPressed: widget.enabled ? widget.onVoice : null,
              ),
            SgIconButton(
              icon: SgIconName.send,
              tooltip: widget.sendTooltip,
              selected: value.text.trim().isNotEmpty,
              filled: true,
              onPressed: widget.enabled && value.text.trim().isNotEmpty
                  ? _send
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// CMP-20
class SgTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SgTopAppBar({
    required this.title,
    this.leading,
    this.actions = const [],
    this.large = false,
    super.key,
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;
  final bool large;

  @override
  Size get preferredSize => Size.fromHeight(
        large
            ? SargoshiComponents.largeTopBarHeight
            : SargoshiComponents.topBarHeight,
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      toolbarHeight: preferredSize.height,
      titleSpacing: SargoshiSpace.s16,
    );
  }
}

// CMP-21
class SgNavigationDestination {
  const SgNavigationDestination({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });

  final String label;
  final SgIconName icon;
  final SgIconName? selectedIcon;
}

class SgBottomNavigation extends StatelessWidget {
  const SgBottomNavigation({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  }) : assert(destinations.length == 4);

  final List<SgNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SargoshiComponents.bottomNavigationHeight,
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations
            .map(
              (destination) => NavigationDestination(
                label: destination.label,
                icon: SgIcon(destination.icon),
                selectedIcon: SgIcon(
                  destination.selectedIcon ?? destination.icon,
                  selected: true,
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

// CMP-22
class SgNavigationRail extends StatelessWidget {
  const SgNavigationRail({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.extended = false,
    super.key,
  }) : assert(destinations.length >= 4 && destinations.length <= 6);

  final List<SgNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      minWidth: SargoshiComponents.navigationRailWidth,
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      destinations: destinations
          .map(
            (destination) => NavigationRailDestination(
              label: Text(destination.label),
              icon: SgIcon(destination.icon),
              selectedIcon: SgIcon(
                destination.selectedIcon ?? destination.icon,
                selected: true,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

// CMP-23
class SgBottomSheet extends StatelessWidget {
  const SgBottomSheet({
    required this.child,
    this.title,
    super.key,
  });

  final Widget child;
  final String? title;

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SargoshiShape.sheet),
        ),
      ),
      builder: (context) => SgBottomSheet(child: builder(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        SargoshiSpace.s24,
        SargoshiSpace.s12,
        SargoshiSpace.s24,
        SargoshiSpace.s24,
      ),
      decoration: BoxDecoration(
        color: colors.dusk,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SargoshiShape.sheet),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: SargoshiSpace.s40,
              height: SargoshiSpace.s4,
              decoration: BoxDecoration(
                color: colors.mist,
                borderRadius: BorderRadius.circular(SargoshiShape.chip),
              ),
            ),
          ),
          if (title != null) ...[
            const SizedBox(height: SargoshiSpace.s20),
            Text(title!, style: SargoshiType.title),
          ],
          const SizedBox(height: SargoshiSpace.s16),
          child,
        ],
      ),
    );
  }
}

// CMP-24
abstract final class SgDialog {
  static Future<bool?> confirmDestructive({
    required BuildContext context,
    required String title,
    required String message,
    required String cancelLabel,
    required String confirmLabel,
  }) {
    final colors = context.sgColors;
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        constraints: const BoxConstraints(
          maxWidth: SargoshiComponents.dialogMaxWidth,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SargoshiShape.sheet),
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colors.coral,
              foregroundColor: colors.ink,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }
}

// CMP-25
abstract final class SgSnackbar {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show({
    required BuildContext context,
    required String message,
    String? undoLabel,
    VoidCallback? onUndo,
  }) {
    assert((undoLabel == null) == (onUndo == null));
    final colors = context.sgColors;
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: SargoshiMotion.undoSnackbar,
        backgroundColor: colors.dusk3,
        behavior: SnackBarBehavior.floating,
        action: undoLabel == null
            ? null
            : SnackBarAction(
                label: undoLabel,
                onPressed: onUndo!,
                textColor: colors.glow,
              ),
      ),
    );
  }
}

// CMP-26
enum SgBannerVariant { info, warning }

class SgBanner extends StatelessWidget {
  const SgBanner({
    required this.title,
    required this.message,
    required this.variant,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.dismissTooltip,
    super.key,
  }) : assert((actionLabel == null) == (onAction == null)),
       assert(onDismiss == null || dismissTooltip != null);

  final String title;
  final String message;
  final SgBannerVariant variant;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;
  final String? dismissTooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    final accent = variant == SgBannerVariant.warning ? colors.amber : colors.sky;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(SargoshiSpace.s16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: SargoshiOpacity.pressedOverlay),
        borderRadius: BorderRadius.circular(SargoshiShape.card),
        border: Border.all(color: accent),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgIcon(
            variant == SgBannerVariant.warning
                ? SgIconName.safetyWarning
                : SgIconName.verified,
            color: accent,
          ),
          const SizedBox(width: SargoshiSpace.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: SargoshiType.titleS),
                const SizedBox(height: SargoshiSpace.s4),
                Text(message, style: SargoshiType.body),
                if (actionLabel != null) ...[
                  const SizedBox(height: SargoshiSpace.s8),
                  TextButton(
                    onPressed: onAction,
                    child: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null)
            SgIconButton(
              icon: SgIconName.delete,
              tooltip: dismissTooltip!,
              onPressed: onDismiss,
            ),
        ],
      ),
    );
  }
}

// CMP-27
enum SgAlertSeverity { info, notice, warning, critical }

class SgAlertCard extends StatelessWidget {
  const SgAlertCard({
    required this.title,
    required this.message,
    required this.severity,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : assert((actionLabel == null) == (onAction == null));

  final String title;
  final String message;
  final SgAlertSeverity severity;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    final accent = switch (severity) {
      SgAlertSeverity.info => colors.sky,
      SgAlertSeverity.notice => colors.mint,
      SgAlertSeverity.warning => colors.amber,
      SgAlertSeverity.critical => colors.coral,
    };
    return SgCard(
      variant: SgCardVariant.alert,
      alertColor: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: SargoshiType.titleS),
          const SizedBox(height: SargoshiSpace.s8),
          Text(message, style: SargoshiType.body),
          if (actionLabel != null) ...[
            const SizedBox(height: SargoshiSpace.s8),
            SgButton(
              label: actionLabel!,
              variant: SgButtonVariant.ghost,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}

// CMP-28
class SgPinPad extends StatefulWidget {
  const SgPinPad({
    required this.onDigit,
    required this.onBackspace,
    required this.backspaceTooltip,
    required this.digitSemanticLabel,
    this.scrambled = false,
    super.key,
  });

  final ValueChanged<int> onDigit;
  final VoidCallback onBackspace;
  final bool scrambled;
  final String backspaceTooltip;
  final String Function(int digit) digitSemanticLabel;

  @override
  State<SgPinPad> createState() => _SgPinPadState();
}

class _SgPinPadState extends State<SgPinPad> {
  late List<int> _keys;

  @override
  void initState() {
    super.initState();
    _generateKeys();
  }

  @override
  void didUpdateWidget(covariant SgPinPad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrambled != widget.scrambled) _generateKeys();
  }

  void _generateKeys() {
    if (widget.scrambled) {
      final digits = List<int>.generate(10, (index) => index);
      digits.shuffle(math.Random.secure());
      _keys = [...digits.take(9), -1, digits.last, -2];
    } else {
      _keys = [1, 2, 3, 4, 5, 6, 7, 8, 9, -1, 0, -2];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _keys.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: SargoshiComponents.pinKeyGap,
        crossAxisSpacing: SargoshiComponents.pinKeyGap,
        mainAxisExtent: SargoshiComponents.pinKeySize,
      ),
      itemBuilder: (context, index) {
        final value = _keys[index];
        if (value == -1) return const SizedBox.shrink();
        if (value == -2) {
          return IconButton(
            tooltip: widget.backspaceTooltip,
            onPressed: widget.onBackspace,
            icon: SgIcon(SgIconName.delete, color: colors.moon),
          );
        }
        return Semantics(
          button: true,
          label: widget.digitSemanticLabel(value),
          child: Material(
            color: colors.dusk2,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => widget.onDigit(value),
              child: Center(
                child: Text(
                  value.toString(),
                  style: SargoshiType.display.copyWith(color: colors.moon),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// CMP-29
class SgStatRing extends StatelessWidget {
  const SgStatRing({
    required this.value,
    required this.valueLabel,
    required this.label,
    this.color,
    super.key,
  });

  final double value;
  final String valueLabel;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    final accent = color ?? colors.mint;
    return SizedBox(
      width: SargoshiComponents.statRingSize,
      height: SargoshiComponents.statRingSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: value.clamp(0, 1).toDouble(),
              strokeWidth: SargoshiComponents.statRingStroke,
              backgroundColor: colors.dusk3,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(valueLabel, style: SargoshiType.titleS),
              Text(label, style: SargoshiType.caption),
            ],
          ),
        ],
      ),
    );
  }
}

// CMP-30
enum SgProgressVariant { linear, ring, segmented }

class SgProgress extends StatelessWidget {
  const SgProgress({
    required this.value,
    this.variant = SgProgressVariant.linear,
    this.segments = 5,
    this.label,
    super.key,
  }) : assert(segments >= 4 && segments <= 10);

  final double value;
  final SgProgressVariant variant;
  final int segments;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    final progress = value.clamp(0, 1).toDouble();
    return switch (variant) {
      SgProgressVariant.linear => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) Text(label!, style: SargoshiType.caption),
            ClipRRect(
              borderRadius: BorderRadius.circular(SargoshiShape.chip),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: SargoshiComponents.progressMinThickness,
                backgroundColor: colors.dusk3,
                valueColor: AlwaysStoppedAnimation<Color>(colors.mint),
              ),
            ),
          ],
        ),
      SgProgressVariant.ring => SizedBox(
          width: SargoshiComponents.statRingSize,
          height: SargoshiComponents.statRingSize,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: SargoshiComponents.progressMaxThickness,
            backgroundColor: colors.dusk3,
            valueColor: AlwaysStoppedAnimation<Color>(colors.mint),
          ),
        ),
      SgProgressVariant.segmented => Row(
          children: List.generate(
            segments,
            (index) => Expanded(
              child: Container(
                height: SargoshiComponents.progressMinThickness,
                margin: EdgeInsetsDirectional.only(
                  end: index == segments - 1 ? 0 : SargoshiSpace.s4,
                ),
                decoration: BoxDecoration(
                  color: (index + 1) / segments <= progress
                      ? colors.mint
                      : colors.dusk3,
                  borderRadius: BorderRadius.circular(SargoshiShape.chip),
                ),
              ),
            ),
          ),
        ),
    };
  }
}

// CMP-31
enum SgSkeletonVariant { listRow, gridCell, card }

class SgSkeleton extends StatelessWidget {
  const SgSkeleton({
    required this.variant,
    this.width,
    super.key,
  });

  final SgSkeletonVariant variant;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    Widget block(double height, [double? blockWidth]) => Container(
          width: blockWidth,
          height: height,
          decoration: BoxDecoration(
            color: colors.dusk2,
            borderRadius: BorderRadius.circular(SargoshiShape.button),
          ),
        );

    return switch (variant) {
      SgSkeletonVariant.listRow => SizedBox(
          width: width,
          height: SargoshiComponents.listTileTwoLine,
          child: Row(
            children: [
              block(SargoshiSpace.s48, SargoshiSpace.s48),
              const SizedBox(width: SargoshiSpace.s12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    block(SargoshiSpace.s12, double.infinity),
                    const SizedBox(height: SargoshiSpace.s8),
                    block(SargoshiSpace.s8, SargoshiSpace.s64 * 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      SgSkeletonVariant.gridCell => AspectRatio(
          aspectRatio: 1,
          child: block(double.infinity, width),
        ),
      SgSkeletonVariant.card => Card(
          child: Padding(
            padding: const EdgeInsets.all(SargoshiSpace.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                block(SargoshiSpace.s48, double.infinity),
                const SizedBox(height: SargoshiSpace.s16),
                block(SargoshiSpace.s12, double.infinity),
                const SizedBox(height: SargoshiSpace.s8),
                block(SargoshiSpace.s8, SargoshiSpace.s64 * 2),
              ],
            ),
          ),
        ),
    };
  }
}

// CMP-32
class SgEmptyState extends StatelessWidget {
  const SgEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  }) : assert((actionLabel == null) == (onAction == null));

  final SgIconName icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.sgColors;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: SargoshiLayout.welcomeContentMaxWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.all(SargoshiSpace.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SgIcon(
                icon,
                size: SargoshiComponents.emptyIconSize,
                color: colors.vaultLilac,
                emptyState: true,
              ),
              const SizedBox(height: SargoshiSpace.s24),
              Text(
                title,
                style: SargoshiType.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SargoshiSpace.s8),
              Text(
                message,
                style: SargoshiType.body,
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: SargoshiSpace.s24),
                SgButton(
                  label: actionLabel!,
                  onPressed: onAction,
                  expand: true,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
