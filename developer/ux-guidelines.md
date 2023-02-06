# User Experience Guidelines

Since helloSystem is intended to be friendly and welcoming to switchers from the Mac, it is important to understand the underlying concepts and design considerations that went into the Mac. We are not aiming to create a 1:1 replica, but something that is generally consistent with the underlying general user experience (UX) philosophy, which has been openly documented.

## Macintosh Human Interface Guidelines

What are the design principles that make user interfaces "Mac-like"? Apple spelled them out for us publicly 30 years ago in a book, the Macintosh Human Interface Guidelines. Besides describing what makes user interfaces "Mac-like", the book also explains general concepts like how to perform user testing.

> If you are a designer, a human interface professional, or an engineer, this book contains information you can use to design and create products that fit the Macintosh model. It provides background information that can help you plan and make decisions about your product design. __Even if you don’t design and develop products for the Macintosh, reading this book will help you to understand the Macintosh interface.__

Source: [Apple Computer, Inc., 1992, Macintosh Human Interface Guidelines, First Printing, November 1992. Addison-Wesley Publishing Company. ISBN 0-201-62216-5](https://dl.acm.org/doi/book/10.5555/573097)

## Using the global menu bar

### Walker, N & Smelcer, 1990 (Superiority of the global menu bar)

Referred to in the Macintosh Human Interface Guidelines with highest praise:

> A seminal paper on why pull-down menus are superior to any other kind.
> Everyone who designs for the screen must read this paper.

This paper provides empirical evidence on the superiority of global menus.

> Systems that maximize the percentage of menu items with borders will have a decided
advantage over other menu systems.
> 
> In this experiment the initial movement to the pull-down menus was larger that
average distance required to reach the top of a 19 inch diagonal screen, yet the pull-downs still significantly outperformed the walking menus. Therefore, it may be
more efficient to place menus at the top of the window

Source: Walker, N & Smelcer, JB 1990, A comparison of selection times from walking and pull-down menus. in JC Chew & J Whiteside (eds), Proceedings of the SIGCHI Conference on Human Factors in Computing Systems, CHI 1990. Association for Computing Machinery, pp. 221-225, 1990 SIGCHI Conference on Human Factors in Computing Systems, CHI 1990, Seattle, United States, 4/1/90. <https://dl.acm.org/doi/pdf/10.1145/97243.97277>

## Avoiding hidden menus hamburger icons

Menus hidden behind hamburger menus have been [proven to hurt user experience]( https://www.nngroup.com/articles/hamburger-menus/). They should not be used. The global menu bar should be used instead.

## Avoiding configuration options

Configuration options add complexity to software, increase the test matrix, and make software harder to support (e.g., over the phone) because no two systems behave exactly the same way depending on how they were configured. Hence in helloSystem we want to avoid unnecessary user-facing configuration options whenever possible. We take great care to set sensible defaults and make things "just work" as expected (in line with our design objectives) out of the box, without the need for configuration. KDE Plasma is recommended as an alternative for users who wish to configure and customize every aspect of the system.
