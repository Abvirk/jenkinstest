namespace HelloWorld
{
    class Program
    {
        static void Main(string[] args)
        {
            var startTimeSpan = TimeSpan.Zero;
var periodTimeSpan = TimeSpan.FromSeconds(5);
Console.WriteLine("Docker is buliding sonarqube");
var timer = new System.Threading.Timer((e) =>
{
Console.WriteLine($"Running at {DateTime.Now.ToLocalTime()}");
}, null, startTimeSpan, periodTimeSpan);
Console.ReadLine();
        }
    }
}