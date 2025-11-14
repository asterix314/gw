#import "/assignment.typ": *

#show: assignment.with(
  title: [Assignment 2],
  course: [COMP9311/25T3 Introduction to Database Systems],
  university-logo: image("unsw.png", width: 3.5cm),
  authors: (
    (
      name: "John Doe",
      email: "john.doe@example.com",
      student-no: "992138",
    ),
  ),
  heading-numbering: none,
  watermark: true
)


= Question 1

Consider a relation $R(A, B, C, D, E, G, H, I, J)$ and its FD set $F = {A B -> C D I, B J -> E H I, E H -> A C, I -> B, H C D -> A G}$. Regarding the following questions. Give and justify your answers if the question is specified.

1. Check if  $A B D -> H$. Justify your answer.

#sol[$A B D arrow.not H$ because according to $F$, the only immediate determinant of $H$ is $B J$ ($B J -> E H I$). But $J$ is independent as it does not appear on the right hand side of any dependencies. Therefore there is no dependency chain that leads from $A B D$ to $H$ because it would be broken at $J$.]

2. Find all the candidate keys for $R$.

#sol[$J B$ and $J I$ are the only candidate keys.

Any candidate key must have $J$, as is explained in (1), and cannot have $G$, as $G$ only appears on the right hand side. First we pair $J$ with any one $x$ of $A B C D E H I$ and compute ${J, x}^+$. We find that $J B$ is a candidate key because $
  J B & -> J B E H I wide         && (B J -> E H I) \
      & -> J B E H I A C wide     && (E H -> A C) \
      & -> J B E H I A C D wide   && (A B -> C D I) \
       & -> J B E H I A C D G wide && (H C D -> A G)
$ and it is minimal. $J I$ is also a candidate key because $I -> B$. In fact, $J B$ and $J I$ are the only candidate keys. This is because for any other candidate key, it must

- have $J$ but not $G$, and
- not have $B$ or $I$ (otherwise not minimal).

It follows that the candidate must be a subset of $J A C D E H$ ($R$ with $G B I$ removed), which is not a superkey itself (e.g. $B$ cannot be implied from it). So no such candidate keys exist.]

3. Determine the highest normal form of $R$ with respect to $F$. Justify your answer.

#sol[First, its easy to see $R$ is not 3NF, for many of the dependencies are non-prime to non-prime ($B J I$ are the only prime attributes), E.g. $E H -> A C$, in violation of 3NF.

To check if 2NF holds, note that the only dependency in $F$ with the LHS being a partial key is $I -> B$, and in this case the RHS is also a prime attribute. So there is no chance of a partial key determining any non-prime attributes. Therefore we conclude $R$ is 2NF.]

4. Find a minimal cover $F_m$ for $F$ and show the steps involved.

#sol[There are 3 steps.
#set enum(numbering: "Step 1.")

1. Reduce RHS to singletons.
  #set math.vec(delim: none)
  $
    F' = {
      vec(A B -> C, A B -> D, A B -> I) wide
      vec(B J -> E, B J -> H, B J -> I) wide
      vec(E H -> A, E H -> C) wide I -> B wide
      vec(H C D -> A, H C D -> G)
    }
  $

2. Minimize the LHS. E.g. for $A B -> C$, check if $A -> C$ or $B -> C$ already. But $A^+ = {A}$ and $B^+ = {B}$, so $A arrow.not C$ and $B arrow.not C$, the LHS of $A B -> C$ cannot be reduced.

  After manually checking every FD in $F'$, we find that all the LHS are already minimal. So no progress at this step.

3. Remove redundant FD's. E.g. for $A B -> C$, temporarily remove it from $F'$ and check if $(A B)^+$ still includes $C$ -- the answer is no, so $A B -> C$ is not redundant.

  Repeat for all FD's, and we find only $B J -> I$ is redundant, because $B J -> E H -> A$ and $A B -> I$.

In conclusion, the minimal cover of $F$ is
#set math.vec(delim: none)
$
  F_m = {
    vec(A B -> C, A B -> D, A B -> I) wide
    vec(B J -> E, B J -> H) wide
    vec(E H -> A, E H -> C) wide I -> B wide
    vec(H C D -> A, H C D -> G)
  }
$]

5. Regarding $F$, does the decomposition $R_1 = {A C D G}$, $R_2 = {B D E H J}$, $R_3 = {C D I}$ of $R$ satisfy the lossless join property? Please justify your answer.

#sol[Write down the matrix for testing lossless join:

#figure(
  table(
    columns: 10,
    stroke: none,
    table.header[][A][B][C][D][E][G][H][I][J],
    table.hline(),
    [*$R_1$*], table.vline(), [1], [0], [1], [1], [0], [1], [0], [0], [0],
    [*$R_2$*], [0], [1], [0], [1], [1], [0], [1], [0], [1],
    [*$R_3$*], [0], [0], [1], [1], [0], [0], [0], [1], [0],
  ),
)

And we have to stop here, for 2 rows of all 1's cannot be found at the columns corresponding to any LHS of $F$. Therefore the decomposition ${R_1, R_2, R_2}$ does not satisfy the lossless join property.]

6. Provide a step-by-step lossless decomposition of $R$ into BCNF normal form.

#sol[To decompose $R$ into BCNF:
#set enum(numbering: "Step 1.")

1. Check the FD $A B -> C D I$ on $R$. But $A B$ is not a superkey by way of Question (2), so decompose $R$ into

  - $R_1 = (A B C D I)$ with $F_1 = {A B -> C D I, I -> B}$ and
  - $R_2=(A B E G H J)$ with $F_2 = {B J -> E H, E H -> A, B J -> G}$. ($B J -> G$ is added because $B J$ is a key of $R$)

2. Check $I -> B$ on $R_1$. But $I$ is not a superkey ($I arrow.not A$), so decompose $R_1$ into

  - $R_11 = (I B)$ with $F_11 = {I -> B}$ and
  - $R_12 = (A C D I)$ with $F_12 = {A I -> C D}$. ($I -> B => A I -> A B -> C D$)

  Both $R_11$ and $R_12$ are BCNF as each has only one FD stating the key.

3. Check $E H -> A$ on $R_2$. But $E H$ is not a superkey ($E H arrow.not B$), so decompose $R_2$ into

  - $R_21 = (E H A)$ with $F_21 = {E H -> A}$ and
  - $R_22 = (B J E H G)$ with $F_22 = {B J -> E H G}$. 
  
  Again, both $R_21$ and $R_22$ are BCNF as each has only one FD stating the key.

In summary, $R$ can be decomposed losslessly into 4 BCNF relations:

  - $R_11 = (I B)$ with $F_11 = {I -> B}$
  - $R_12 = (A C D I)$ with $F_12 = {A I -> C D}$
  - $R_21 = (E H A)$ with $F_21 = {E H -> A}$
  - $R_22 = (B J E H G)$ with $F_22 = {B J -> E H G}$]

= Question 2

Consider the schedule below. Here, $R(dot)$  and $W(dot)$  stand for "Read" and "Write", respectively. T1, T2, T3, T4 and T5 represent five transactions and ti represents a time slot.

#let schedule = (
  (trn: 1, time: 9, oper: "W", res: "Z"),
  (trn: 1, time: 14, oper: "R", res: "X"),
  (trn: 1, time: 16, oper: "W", res: "X"),
  (trn: 2, time: 1, oper: "R", res: "X"),
  (trn: 2, time: 5, oper: "R", res: "Y"),
  (trn: 2, time: 12, oper: "W", res: "Y"),
  (trn: 3, time: 3, oper: "R", res: "Y"),
  (trn: 3, time: 8, oper: "W", res: "Y"),
  (trn: 3, time: 11, oper: "W", res: "Z"),
  (trn: 4, time: 4, oper: "R", res: "X"),
  (trn: 4, time: 6, oper: "W", res: "X"),
  (trn: 4, time: 13, oper: "R", res: "X"),
  (trn: 4, time: 15, oper: "R", res: "Z"),
  (trn: 5, time: 2, oper: "R", res: "Z"),
  (trn: 5, time: 7, oper: "W", res: "Z"),
  (trn: 5, time: 10, oper: "W", res: "X"),
)

#figure(
  table(
    columns: 17,
    align: center,
    fill: (x, y) => if x > 0 and calc.odd(y) {
      blue.transparentize(85%)
    },
    stroke: (x, y) => if x > 0 and y > 0 {
      blue + .5pt
    },
    table.header(
      [],
      ..range(1, 17).map(i => strong([t] + str(i))),
    ),
    ..for trn in range(1, 6) {
      (strong([T] + str(trn)),)
      for time in range(1, 17) {
        let found = schedule.find(
          x => (x.trn, x.time) == (trn, time),
        )
        if found != none {
          (
            eval(
              mode: "math",
              found.oper + "(" + found.res + ")",
            ),
          )
        } else { ([],) }
      }
    },
  ),
  placement: none,
  caption: [Note: Each transaction begins at the time slot of its first operation and commits right after its last operation (same time slot).],
)

Regarding the following questions. Give and justify your answers.

1. Assume a checkpoint is made between t6 and t7, what should be done to the five transactions when the crash happens between t13 and t14.

#sol[At the time of the checkpoint, T2, T3, T4, and T5 are active, while T1 has not begun. So all 5 transactions are either to be undone or redone, depending on whether they have committed at the time of crash.

- Undo: T1 and T4 -- not committed at time of crash.
- Redo: T2, T3, T5 -- committed before crash.]

2. Is the transaction schedule conflict serializable? Give the full precedence graph to justify your answer.

#sol[Let's reorganize the schedule by resources, as is shown below.

#figure(
  table(
    columns: 17,
    align: center,
    stroke: none,
    table.header([],..range(1, 17).map(str)),
    table.hline(),
    ..for res in "XYZ" {
      (res, table.vline())
      for time in range(1, 17) {
        let entry = schedule.find(
          s => (s.time, s.res) == (time, res))
        if entry != none {
          ([#entry.trn;#entry.oper],)
        } else {([],)}
      }
    }
  )
)

Here the table entry is "transaction-operation", e.g. "5W" means transaction 5 performs a read. Then reading the rows, we can easily gather the precedences: any $i"R"$ or $i"W"$ before a $j "W"$ gives a precedence edge $i -> j$ ($i != j$).

#grid(
  columns:  (1.2fr, 1fr),
  align: (left + top, horizon + right),
  gutter: 1em,
  [- X: T2 #sym.arrow T4, T2 #sym.arrow T5, T4 #sym.arrow T5, T2 #sym.arrow T1,\ T4 #sym.arrow T1, T5 #sym.arrow T1.
  - Y: T2 #sym.arrow T3, T3 #sym.arrow T2. (cycle)
  - Z: T5 #sym.arrow T1, T5 #sym.arrow T3, T1 #sym.arrow T3.
  
  The transaction schedule is not conflict serializable due to the presence of cycles in the precedence graph.],
  diagram(
    node-stroke: 1.5pt + luma(50%),
    edge-stroke: .7pt + luma(50%),
    node-shape: circle,
    node((1,0), [T4], name: <t4>),
    edge(<t5>, "-|>"),
    edge(<t1>, "-|>"),
    node((-1,-1), [T5], name: <t5>),
    edge(<t1>, "-|>"),
    edge(<t3>, "-|>"),
    node((0,0), [T1], name: <t1>),
    edge(<t3>, "-|>"),
    node((-2,0), [T2], name: <t2>),
    edge(<t3>, "-|>", bend: 20deg),
    edge(<t1>, "-|>", bend: -40deg),
    edge(<t4>, "-|>", bend: -50deg),
    edge(<t5>, "-|>"),
    node((-1,0), [T3], name: <t3>),
    edge(<t2>, "-|>", bend: 20deg)
    )
)]

3. Construct a schedule (which is different from above) of these five transactions which causes deadlock when using two-phase locking protocol. You should clearly indicate all the locks and the corresponding unlocks in your schedule. If no such schedule exists, explain why.

#sol[A schedule of all 5 transactions is a bit overwhelming for me. I'll just take T1 and T4 as an example, as they both operate on resources X and Z. The sequence of their operations are:

- T1: `write(Z)` #sym.arrow `read(X)` #sym.arrow `write(X)`
- T4: `read(X)` #sym.arrow `write(X)` #sym.arrow `read(X)` #sym.arrow `read(Z)`

A two-phase locking protocol requires that the transaction does not obtain new locks after it has released any locks. In the following schedule, T1 and T4 can execute simultaneously.

#show raw: zebraw.with(
    background-color: black.transparentize(100%),
    highlight-color: silver.transparentize(20%),
    highlight-lines: range(8,13)
)

#table(
  columns: (1fr, 1fr, 1fr),
  stroke: none,
  align: center,
  table.header[T1][T4][concurrency-control],
  table.hline(),
  [```
  lock-X(Z)

  write(Z)
  lock-X(X)




  read(X)
  write(X)
  unlock(X)
  unlock(Z)
  ```],
  table.vline(),
  [```
  lock-X(X)


  read(X)
  write(X)
  read(X)
  lock-S(Z)

  read(Z)
  unlock(Z)
  unlock(X)

  ```],
  table.vline(),
  [```

  grant-X(Z, T1)
  grant-X(X, T4)




  <- dead lock




  ```]
)]


= Question 3

Consider the following query:

P1, P2, P3, P1, P4, P1, P5, P3, P6, P2, P3, P4, P6, P2, P5

(The user is trying to read page 1 from disk, then page 2, page 3, ...) Assume there are 3 buffers in the buffer pool.

1. Sketch the process of how blocks are replaced in the Least Recently Used (LRU)  policy.

#sol[See sketch below.]

2. Sketch the process of how blocks are replaced in the Most Recently Used (MRU) policy.

#sol[See sketch below.]

3. Sketch  the  process  of  how  blocks  are  replaced  in  the  First  In  First  Out (FIFO)  policy.

#sol[The sketch below illustrates all 3 policies side by side. The "queue" is a priority queue implementing the policy, where the number at the left corresponds to the next buffer to be replaced.

  #figure(
    image("simulation.png"),
    caption: [Simulation sketch of replacement policies LRU, MRU, and FIFO under the given query sequence.\
      #text(orange)[■] cache miss and replace #h(2em) #text(green)[■]  cache hit.],
  )]

4. Among LRU, MRU and FIFO policies, which one performs better in the given query? Why?

#sol[Let's calculate the hit rate $r$ of the policies by counting green cells:
  $
    r_"LRU" & = 5\/15 approx 0.33 \
    r_"MRU" & = 5\/15 approx 0.33 \
    r_"FIFO" & = 4\/15 approx 0.27
  $

So for the given sequence of queries, LRU and MRU perform equally well. FIFO performs worse.]
