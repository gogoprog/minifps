package ecs;

class Entity {
    public var position:math.Vector3 = [0, 0, 0];
    public var pitch:Float = 0;
    public var yaw:Float = 0;
    public var scale:Float = 1;
    private var components:Map<String, Dynamic> = [];

    public function new() {
    }

    public function add<T>(componentClass:Class<T>):T {
        var instance = Type.createInstance(componentClass, []);
        components[Type.getClassName(componentClass)] = instance;
        return instance;
    }

    public function remove<T>(componentClass:Class<T>) {
        components.remove(Type.getClassName(componentClass));
    }

    public function has<T>(componentClass:Class<T>):Bool {
        return components.exists(Type.getClassName(componentClass));
    }

    public function get<T>(componentClass:Class<T>):T {
        return components.get(Type.getClassName(componentClass));
    }
}
