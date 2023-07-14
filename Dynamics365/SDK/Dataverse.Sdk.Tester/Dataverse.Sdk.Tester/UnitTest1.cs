using Microsoft.Azure.ServiceBus.Primitives;
using Microsoft.PowerPlatform.Dataverse.Client;
using Microsoft.Xrm.Sdk;
using System.Collections.Concurrent;

namespace Dataverse.Sdk.Tester
{
    public class NonTestClass
    {
        public void BasicServiceClientConnection_shouldfail()
        {
            ServiceClient svc = new ServiceClient("");
            svc.Create(new Entity("account"));
        }

        public void BasicServiceClientConnection_CookieAffinitySetToFalse_shouldpass()
        {
            ServiceClient svc = new ServiceClient("");
            svc.EnableAffinityCookie = false;
            svc.Create(new Entity("account"));
        }
        public void BasicServiceClientConnection_CookieAffinitySetToTrue_shouldfail()
        {
            ServiceClient svc = new ServiceClient("");
            svc.EnableAffinityCookie = true;
            svc.Create(new Entity("account"));
        }
    }
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestMethod1()
        {
            ServiceClient svc = new ServiceClient("");

        }

        public void BasicServiceClientConnection()
        {
            ServiceClient svc = new ServiceClient("");
        }

        /// <summary>
        /// Creates records in parallel
        /// </summary>
        /// <param name="serviceClient">The authenticated ServiceClient instance.</param>
        /// <param name="entityList">The list of entities to create.</param>
        /// <returns>The id values of the created records.</returns>
        static async Task<Guid[]> CreateRecordsInParallel(
            ServiceClient serviceClient,
            List<Entity> entityList)
        {
            ConcurrentBag<Guid> ids = new();

            // Disable affinity cookie
            //serviceClient.EnableAffinityCookie = false;

            var parallelOptions = new ParallelOptions()
            {
                MaxDegreeOfParallelism =
                serviceClient.RecommendedDegreesOfParallelism
            };

            await Parallel.ForEachAsync(
                source: entityList,
                parallelOptions: parallelOptions,
                async (entity, token) =>
                {
                    ids.Add(await serviceClient.CreateAsync(entity, token));
                });

            return ids.ToArray();
        }


    }
}