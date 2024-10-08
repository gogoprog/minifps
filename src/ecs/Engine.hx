package ecs;

@:allow(ecs.Engine)
class System {
    private var engine:Engine;
    private var componentClasses:Array<Class<Dynamic>> = [];

    public function new() {
    }

    public function update(dt) {
        var selection = [];

        for(e in engine.entities) {
            var correct = true;

            for(klass in componentClasses) {
                if(!e.has(klass)) {
                    correct = false;
                    break;
                }
            }

            if(correct) {
                selection.push(e);
            }
        }

        for(e in selection) {
            updateEntity(e, dt);
        }
    }

    public function updateEntity(e:Entity, dt:Float) {
    }

    public function requires<T>(componentClass:Class<T>) {
        componentClasses.push(componentClass);
    }
}

@:allow(ecs.System)
class Engine {
    public function new() {
    }

    public function update(dt) {
        for(system in enabledSystems) {
            system.update(dt);
        }
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

    public function add(entity:Entity) {
        entities.push(entity);
    }

    public function remove(entity:Entity) {
        entities.remove(entity);
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
            target_system.engine = this;
        }

        return target_system;
    }

    private var allSystems:Array<System> = [];
    private var enabledSystems:Array<System> = [];
    private var entities:Array<Entity> = [];
}
