using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using DemoWebApiWithSqlServerInDocker.Model;

    public class ProductDbContext : DbContext
    {
        public ProductDbContext (DbContextOptions<ProductDbContext> options)
            : base(options)
        {
        }

        public DbSet<DemoWebApiWithSqlServerInDocker.Model.Product> Product { get; set; } = default!;
    }
