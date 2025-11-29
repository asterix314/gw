#import "/assignment.typ": assignment, sol, zebraw

#show: assignment.with(
  title: [Assessment Task 2 (CW)],
  course: [DTS207TC: Database Development and Design],
  university-logo: image("logo.png", width: 6cm),
  figure-numbering: none,
  enum-numbering: "(a.i)",
  heading-numbering: none,
  raw-numbering: false,
  watermark: true
)

= Question 6: Storage Management

In a database storage system, the cache hit rate has a significant impact on its performance. Different cache strategies will result in different cache hit ratios. Now, we have recorded 2 datasets (please download from LMO), containing CPU access requests to memory for a period of time. They both have 10,000 items from addresses 0 to 63. We will simulate the process of the CPU reading and caching data from the memory through a program in the table below (also can be download from LMO). Please run the program to compare the hit rates of different strategies:

```
# simulation program omitted
```

You need to analyze the characteristics of this data and analyze why the hit rates of the two strategies are different on the two data sets. Design and implement a strategy which can achieve better results than the `RandomPolicy` strategy on the `trace2` data set. Record the hit rates you observed in the table below (with snapshot).

#align(center, table(
  columns: 3,
  stroke: 0.5pt,
  align: center,
  table.header[Cache Size][RR][Your Policy],
  [1],  [0.0048], [0.0188],
  [2],  [0.0153], [0.0376],
  [3],  [0.0328], [0.0558],
  [4],  [0.0555], [0.0738],
  [5],  [0.0740],  [0.0917],
))


#sol[The simulation result (listed below) shows that `trace1.txt` has a much higher hit rate than `trace2.txt`. The worst hit rate (cap=1 under RR policy) of `trace1.txt` is 0.4337, while the best hit rate (cap=5 under RR policy) of `trace2.txt` is only 0.074.


```
data=1, cap=1,  name=fifo,      hitrate=0.6105
data=1, cap=1,  name=rr,        hitrate=0.4337

data=1, cap=2,  name=fifo,      hitrate=0.6162
data=1, cap=2,  name=rr,        hitrate=0.527

data=1, cap=3,  name=fifo,      hitrate=0.6228
data=1, cap=3,  name=rr,        hitrate=0.5536

data=1, cap=4,  name=fifo,      hitrate=0.629
data=1, cap=4,  name=rr,        hitrate=0.5819

data=1, cap=5,  name=fifo,      hitrate=0.635
data=1, cap=5,  name=rr,        hitrate=0.5948

data=2, cap=1,  name=fifo,      hitrate=0.0018
data=2, cap=1,  name=rr,        hitrate=0.0048

data=2, cap=2,  name=fifo,      hitrate=0.0072
data=2, cap=2,  name=rr,        hitrate=0.0153

data=2, cap=3,  name=fifo,      hitrate=0.0142
data=2, cap=3,  name=rr,        hitrate=0.0328

data=2, cap=4,  name=fifo,      hitrate=0.0181
data=2, cap=4,  name=rr,        hitrate=0.0555

data=2, cap=5,  name=fifo,      hitrate=0.0231
data=2, cap=5,  name=rr,        hitrate=0.074
```

Why? If we take a look at the first 100 items of both trace files, it becomes apparent that the access pattern of `trace1.txt` is localized (it tends to repeatedly access the same items), which will benefit greatly from having a cache, whereas the pattern of `trace2.txt` is rather random, defying any cache design. This trend is verified to be valid over the entirety of both trace files and not just for the first 100 items.

#figure(
  grid(
    columns: 1,
    gutter: 1em,
    image("trace1-100.png"),
    image("trace2-100.png")
  ),
  caption: [Cache access patterns of the first 100 items. Above: `trace1.txt`, below: `trace2.txt`]
)

Now to beat `RandomPolicy` using `trace2.txt`, note that although the overall pattern appears random, the frequency of each item is not exactly the same. For example, the most frequent item (27) appears 188 times, while the least frequent item (31) appears 135 times. Our `custom` policy can perhaps leverage this knowledge to beat `RandomPolicy`, which does not favor one item over another.

#figure(
  image("trace2-hist.png"),
  caption: [Frequency distribution of the items in `trace2.txt`]
)

The implementation is rather simple. Just initialize the cache to be the `cap` most frequent items, and do nothing more.

```py
class CustomPolicy:
    def __init__(self, size):
        self.size = size
        self.cache = [27,2,53,3,49] # most frequently accessed
        self.name = 'custom'

    def access(self, current):
        return current in self.cache[:self.size]
```

Simulation result: (`rr` vs. `custom`) -- indeed `custom` performs a little better across all cache sizes.

```
data=2, cap=1,  name=rr,        hitrate=0.0048
data=2, cap=1,  name=custom,    hitrate=0.0188

data=2, cap=2,  name=rr,        hitrate=0.0153
data=2, cap=2,  name=custom,    hitrate=0.0376

data=2, cap=3,  name=rr,        hitrate=0.0328
data=2, cap=3,  name=custom,    hitrate=0.0558

data=2, cap=4,  name=rr,        hitrate=0.0555
data=2, cap=4,  name=custom,    hitrate=0.0738

data=2, cap=5,  name=rr,        hitrate=0.074
data=2, cap=5,  name=custom,    hitrate=0.0917
```
]



= Question 7: Indexing

Consider a hard disk with a sector size of $B$ = 512 bytes. A `CUSTOMER` file contains approximately $r$ = 40,000 records. Each record includes the following fields: `Name` (30 bytes), `Ssn` (9 bytes), `Email` (30 bytes), `Address` (50 bytes), `Phone` (15 bytes), and `Birth_date` (8 bytes). The `Ssn` field is the primary key. The file system uses 4KB blocks for allocation.

+ Calculate the number of blocks required for an unspanned organization. Then, discuss how the discrepancy between sector size and block size might affect sequential access performance, and whether you would recommend using a different block size for this scenario. (6 marks)

+  The records are physically ordered on `Ssn`. Calculate the maximum number of block accesses for a binary search. During system testing, developers notice that batch queries processing large ranges of `Ssn` values perform 30% slower than expected when using binary search as the primary lookup method. Provide two possible explanations for your scenario. (6 marks)

+ A sparse index is built on `Ssn`. Calculate the number of block accesses to retrieve a record using this index in ideal scenario. During usage, it is found that the performance of the index search continues to decline. Identify two potential reasons why the index performance gain is less than theoretical expectations. (6 marks)

+  A multi-level primary index is constructed. During the design review, two proposals are made: 
  - Proposal A: Use the standard multi-level index structure;
  - Proposal B: Based on Proposal A, select 10 index blocks and cache them persistently in memory.
  Calculate the number of index levels needed for the Proposal A. Then, compare the two proposals in terms of implementation complexity and computation time under a workload with 10% of the Ssn accounting for 90% of the queries. (6 marks)

+ A B+ tree index is built with order $p$ = 50. Calculate the maximum number of records a height 4 tree can index. During maintenance, it's observed that, during frequent insertion and deletion operations, the tree height changes frequently between 3 and 4 even with relatively stable data size. Explain what might be causing this fluctuation and suggest one strategy to stabilize the tree height with optimal performance. (6 marks)

= Question 8: Transaction

Consider a database with a relation `Account(AccountID, Balance)` and initial state:

#align(center, table(
  columns: 2,
  stroke: 0.5pt,
  table.header[AccountID][Balance],
  [1],[110],[2],[10]
))

1. The following transactions represent a fund transfer (`T1`) and a real-time balance report (`T2`) that run concurrently. (10 marks) 
#table(
  columns: (1fr, 1fr),
  stroke: .5pt,
  align: center,
  table.header[`T1` (Transfer)][`T4` (Report)],
  [```
begin transaction
update Account set Balance = Balance - 100 where AccountID = 1;
update Account set Balance = Balance + 100 where AccountID = 2;
commit;
```],
  [```
begin transaction
select sum(Balance) from Account;
commit;
```],
)  
  The application requirement states that the report must never reflect a financially inconsistent state. However, under certain database configurations, T2 might output a total of 20 (instead of the correct 120).

  + Explain under which isolation level(s) this inconsistent total of 20 could occur, and describe the exact sequence of operations in a concurrent schedule that leads to this result.
  
  + The development team proposes using the SERIALIZABLE isolation level to fix this issue. Critically evaluate this proposal by discussing one key advantage and two potential drawbacks (considering both performance and system complexity) for this specific application scenario.

2. Now consider these transactions: a process adding a new account (`T3`), and an audit process calculating the total balance (`T4`). (10 marks)

#table(
  columns: (1fr, 1fr),
  stroke: .5pt,
  align: center,
  table.header[`T1` (Transfer)][`T4` (Report)],
  [```
begin transaction
update Account set Balance = Balance - 100 where AccountID = 1;
update Account set Balance = Balance + 100 where AccountID = 2;
commit;
```],
  [```
begin transaction
select sum(Balance) from Account;
commit;
```],
)


  Suppose the application requirement for the audit is that it must have a consistent view of the database throughout its execution.

  + Is it possible for the two SUM queries in `T4` to return different values? Analyz this possibility under at least three different isolation levels, providing a brief concurrent schedule for each case where the results differ.

  + During a system design review, an engineer suggests: "We can just use the `REPEATABLE READ` isolation level to solve all our concurrency problems in this audit process." Write a brief response evaluating this suggestion. Your response should consider whether this is sufficient, necessary, and practical for meeting the audit requirement.

+ Consider the following observation from production logs: (10 marks)
  - `T5` (Data Maintenance): Inserts 100 new account records in a single transaction.
  - `T6` (Analytics Query): Runs `SELECT COUNT(*) FROM Account;` twice within its transaction and gets two different results. The team initially diagnosed this as a "phantom read."

  + Under which isolation level(s) is this phenomenon possible?

  + A DBA comments: "While this looks like a phantom read, the actual impact and the appropriate fix might be different if those 100 new accounts were all inserted with a zero balance." Briefly explain the DBA's reasoning. Why might the business impact and the technical solution be different if the new accounts have a zero balance, even though the phenomenon looks the same?