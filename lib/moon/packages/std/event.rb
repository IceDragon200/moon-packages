module Moon
  # Base class for every other Event.
  class Event
    @@id = 0

    # @!attribute [r] type
    #   @return [Symbol] type of event
    attr_accessor :type
    # @!attribute [r] id
    #   @return [Integer] id of the event
    attr_accessor :id

    # @param [Symbol] type
    def initialize(type)
      @id = @@id += 1
      @type = type
    end
  end

  # Base class for Input related events.
  class InputEvent < Event
    # @!attribute [r] action
    #   @return [Symbol] state of the key, whether its :press, :release, or :repeat
    attr_accessor :action

    # @!attribute [r] key
    #   @return [Symbol] name of the key
    attr_accessor :key

    # @!attribute [r] mods
    #   @return [Integer] modifiers
    attr_accessor :mods

    alias :button :key
    alias :button= :key=

    # @param [Symbol] key
    # @param [Symbol] action
    # @param [Integer] mods
    def initialize(key, action, mods)
      @action = action
      super @action
      @key = key
      @mods = mods
    end

    # Is the alt modifier active?
    def alt?
      @mods.masked? Moon::Input::MOD_ALT
    end

    # Is the control modifier active?
    def control?
      @mods.masked? Moon::Input::MOD_CONTROL
    end

    # Is the super/winkey modifier active?
    def super?
      @mods.masked? Moon::Input::MOD_SUPER
    end

    # Is the shift modifier active?
    def shift?
      @mods.masked? Moon::Input::MOD_SHIFT
    end
  end

  # Common module for all Keyboard*Events
  module KeyboardEvent
  end

  # Specialized event for char events, mostly generated by typing
  class KeyboardTypingEvent < Event
    include KeyboardEvent

    # @!attribute char
    #   @return [String]
    attr_accessor :char

    # @param [String] char
    def initialize(char)
      @char = char
      super :typing
    end
  end

  # Event used for Keyboard press, repeat and release events
  class KeyboardInputEvent < InputEvent
    include KeyboardEvent
  end

  # Common module for Mouse related events
  module MouseEvent
  end

  # Common module for events that have a generic #position attribute.
  module PositionedEvent
    # @!attribute position
    #   @return [Vector2]
    attr_accessor :position

    # @param [Numeric] x  x-coordinate
    def x=(x)
      @position.x = x
    end

    # @param [Numeric] y  y-coordinate
    def y=(y)
      @position.y = y
    end

    # @return [Numeric] x coordinate
    def x
      @position.x
    end

    # @return [Numeric] y coordinate
    def y
      @position.y
    end
  end

  #
  class MouseInputEvent < InputEvent
    include MouseEvent
    include PositionedEvent

    # @param [Symbol] button
    # @param [Symbol] action
    # @param [Integer] mods
    # @param [Vector2] position
    def initialize(button, action, mods, position)
      @position = position
      super button, action, mods
    end
  end

  class MouseMoveEvent < Event
    include MouseEvent
    include PositionedEvent

    # @param [Numeric] x
    # @param [Numeric] y
    def initialize(x, y)
      @position = Vector2.new(x, y)
      super :mousemove
    end
  end

  class ClickEvent < Event
    include PositionedEvent

    # @!attribute target
    #   @return [Object] click target
    attr_accessor :target

    # @!attribute button
    #   @return [Symbol] button
    attr_accessor :button

    # @param [Object] target
    # @param [Vector2] position
    # @param [Symbol] type
    def initialize(target, position, button, type)
      @target = target
      @position = position
      @button = button
      super type
    end
  end

  # Event used for wrapping other events.
  # This is not used on its own and is normally subclassed.
  # @abstract
  class WrappedEvent < Event
    # @!attribute [r] original_event
    #   @return [Event] the original event
    attr_accessor :original_event

    # @!attribute [r] parent
    #   @return [RenderContainer] parent render context of this event
    attr_accessor :parent

    # @param [Event] event
    # @param [RenderContainer] parent
    # @param [Symbol] type  the event type
    def initialize(event, parent, type)
      @original_event = event
      @parent = parent
      super type
    end
  end

  # Base event for stateful mouse events.
  # @abstract
  class MouseWrappedStateEvent < WrappedEvent
    include MouseEvent
    include PositionedEvent

    # @!attribute state
    #   @return [Boolean] whether its hovering, or not
    attr_accessor :state

    # @param [Event] event
    # @param [RenderContainer] parent
    # @param [Vector2] position
    # @param [Boolean] state  true if the mouse is hovering over the object,
    #                         false otherwise
    # @param [Symbol] type  the event type
    def initialize(event, parent, position, state, type)
      @position = Moon::Vector2[position]
      @state = state
      super event, parent, type
    end
  end

  # Event triggered when the Mouse hovers over an Object.
  class MouseHoverEvent < MouseWrappedStateEvent
    def initialize(event, parent, position, state)
      super event, parent, position, state, :mousehover
    end
  end

  # Event triggered when a Mouse click takes place inside an Object.
  class MouseFocusedEvent < MouseWrappedStateEvent
    def initialize(event, parent, position, state)
      super event, parent, position, state, :mousefocus
    end
  end

  # Event triggered when an Object resizes
  class ResizeEvent < Event
    # @!attribute [r] parent
    #   @return [RenderContainer] parent render context of this event
    attr_accessor :parent

    # @!attribute [r] parent
    #   @return [RenderContainer] parent render context of this event
    attr_accessor :attrs

    # @param [RenderContainer] parent
    def initialize(parent, attrs)
      @parent = parent
      @attrs = attrs
      super :resize
    end
  end
end
