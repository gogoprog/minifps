package ecs;

class System {
    public function new() {
    }

    public function update(dt) {
    }
}

class Engine {
    public function new() {
    }

    public function update(dt) {
    }

    public function enable<T:ecs.System>(systemClass:Class<T>) {
        var target_system:System = getSystem(systemClass);

        if(!enabledSystems.contains(target_system)) {
            enabledSystems.push(target_system);
        }
    }

    public function disable<T:ecs.System>(systemClass:Class<T>) {
        var target_system:System = getSystem(systemClass);

        if(enabledSystems.contains(target_system)) {
            enabledSystems.remove(target_system);
        }
    }

    private function getSystem<T:ecs.System>(systemClass:Class<T>) {
        var target_system:System = null;

        for(system in allSystems) {
            if(Type.getClassName(Type.getClass(system)) == Type.getClassName(systemClass)) {
                target_system = system;
                break;
            }
        }

        if(target_system == null) {
            target_system = Type.createInstance(systemClass, []);
        }

        return target_system;
    }

    private var allSystems:Array<System> = [];
    private var enabledSystems:Array<System> = [];
}
