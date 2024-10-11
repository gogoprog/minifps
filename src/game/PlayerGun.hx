package game;

class PlayerGun {
    public var firing = false;
    public var time = 0.0;
    public var cooldown = 0.5;
    public var owner:ecs.Entity;
}
