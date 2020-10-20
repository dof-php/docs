In general, as you've already stated, instance methods are the better practice. That isn't to say that static methods are downright evil, they simply have a different and unique purpose.

It is important to note that when dealing with instance methods you are working with an object whereas with static methods you are working with a class. When using static methods you will not have access to any of your non-static properties that would normally be available with an instance.

Take the following code as an example:

class Foo
{
    private $bar;
    private static $tavern;

    public function changeBar($value)
    {
        $this->bar = $value;
    }

    public function getBar()
    {
        return $this->bar;
    }

    public static function changeTavern($value)
    {
        self::$tavern = $value;
    }

    public static function getTavern()
    {
        return self::$tavern;
    }
}
Class Foo has a static property $tavern and a non-static property $bar.

If an instance of Foo is created then all properties and methods are available to that object.

If Foo is referenced statically then only the $tavern property, changeTavern() method and getTavern() method are available to the class.

Let's look at the following code:

$foo = new Foo();
$foo->changeBar('Tipsy Turvy');
echo $foo->getBar(); // prints Tipsy Turvy
Since $foo is an instance of Foo, it has access to the entire class. Calling changeBar() will modify the $bar property. To change the $bar property directly from a static method will trigger an error since $bar is available to the object and not the class.

// Calling this method would trigger an error
public static function changeBar($value)
{
    $this->bar = $value; // PHP will crash and burn if you try this.
}
If you want to access class properties from static methods those properties must also be declared static. This will work in the context of the class above. You'll also note that an instance of Foo has no problem reading static properties.

Foo::changeTavern('Stumble Inn');
echo Foo::getTavern(); // prints Stumble Inn
echo $foo->getTavern(); // also prints Stumble Inn
Another thing to remember about static code is that it doesn't behave like an instance. When the first instance of Foo was built both properties $bar and $tavern had no value. If you were to create another instance of Foo you would find that only one of those properties no longer contains a value. (I'm sure by now you can guess which one.)

$anotherFoo = new Foo();
echo $anotherFoo->getBar(); // prints nothing
echo $anotherFoo->getTavern(); // prints Stumble Inn
echo Foo::getTavern(); // prints Stumble Inn
So again, static code means you are working directly with a class - instances mean you are working with an object. It is important to note that any type of class you write that intends to have some kind of state to it should be used as an instance.

Static classes can be a little difficult to debug and test. Testing can be problematic because static properties don't change when you create a new instance. Debugging can also be difficult since the value of a static property is the same across all instances of an class. Make a change in one and you will make that change in all of them. Tracking down which instance made the change is a pain.

Speaking metaphorically, use static classes like sugar - sparingly and only when necessary.

Hope that helps shed some light on the topic.




In addition to that, PHPUnit cannot mock / stub static methods: (phpunit.de/manual/6.5/en/test-doubles.html), so the best practice is to avoid static methods as much as you can unless you mean it. If you take a look at PHP projects on GitHub (e.g., Symfony/Yaml), you can see that the static method is used to instantiate another object conveniently and there's no complex logic inside it




First of all it's not always better but in most cases it is. There are several reasons behind not using static methods:

It's harder to put class on tests if it has static methods
It's harder to extend this class if you want a little different behavior for same method
Very often your static methods in class are just a way of making it global variable which almost always is a bad idea
Refactoring this class will become hell if suddenly you decide that you need some class variable inside static method (change all Class::Method() calls to $c = new Class(); $c->Method())
I strongly invite you to read a little bit more about unit tests. When some other class is using yours with static method, then putting it to tests may be a challenge.

> https://stackoverflow.com/questions/30402978/php-static-vs-instance-method
