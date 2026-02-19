extends Node

###Meeblings###
const meeblingScene := preload("res://Scenes/Meeblings/Base/Meebling.tscn")

###Projectiles###
const fireBallScene := preload("res://Scenes/Projectiles/Fireball/BulletFromCrowdFireball.tscn")
const lightningBoltScene := preload("res://Scenes/Projectiles/ThunderBolt/BulletFromCrowdThunderbolt.tscn")
const frostScene := preload("res://Scenes/Projectiles/Frost/BulletFromCrowdSnowFlake.tscn")
const baseBulletScene := preload("res://Scenes/Projectiles/Bullet/BulletFromCrowd.tscn")
const poisonScene := preload("res://Scenes/Projectiles/Poison/BulletFromCrowdPoisonsmoke.tscn")
const arrowScene := preload("res://Scenes/Projectiles/Arrow/BulletFromCrowdArrow.tscn")

###Effects###
const damageNumberScene := preload("res://Scenes/VisualEffects/AttackEffects/DamageNumber/DamageNumber.tscn")
const XPEffectScene := preload("res://Scenes/VisualEffects/GeneralEffects/XPEffect/XPEffect.tscn")
const splashEffectScene := preload("res://Scenes/VisualEffects/GeneralEffects/SplashEffect/watersplash.tscn")
const bloodExplosionEffectScene := preload("res://Scenes/VisualEffects/AttackEffects/BloodExplosion/bloodExplosion.tscn")
const critEffectScene := preload("res://Scenes/VisualEffects/AttackEffects/CriticalEffect/CritVFX.tscn")
