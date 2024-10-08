#import "@local/question:0.1.0": *
#import "@preview/nth:0.2.0": nth

#let datedisp(
  weekdayname: true,
  date
) = {
  if type(date) != "datetime" { 
    date 
  } else { 
    if weekdayname {
      date.display("[weekday repr:long]")
      [,]
      h(0.25em)
    }
    [#date.display("[month repr:long]") #nth(date.day()), #date.year()]
  }
}

#let semester(date) = {
  let semestername = {
    if (date.month() == 1 and date.day() <= 25) {
      "Winter"
    } else if date.month() < 6 {
      "Spring"
    } else if date.month() < 8  {
      "Summer"
    } else {
      "Fall"
    }
  }
  semestername + " " + str(date.year())
}

#let lines(count) = {
    for _ in range(count) {
        block(spacing: 1.6em, line(length:100%, stroke: rgb("#616A6B")) )
    }
}

#set par(leading: 0.55em, first-line-indent: 1.8em, justify: true)

// The exam function defines how your document looks.
#let exam(
  kind: "Exam", // indicates the type of exam -> Class Test | Pop Quiz | Short Test
  date: datetime.today(),     // date of the exam
  course: "" , // course name
  college: "", // displays the school's name in text or logo in image.
  version: "A", //Letter or Number
  instructor: "", // instructor name
  lhead: "",
  chead: "",
  rhead: "",
  lfoot: "", 
  rfoot: "",
  intro: none,  // used to display a hint about clean writing and if grammar is valued, etc...
  sol: false, // show solutions
  namebox: true, // show name and grade box
  body
) = {
  // Set page, headers and footers for the main body
  set page(
    header: {
      set block(spacing: 0.5em)
      set text(12pt, weight: "bold")
      if college != "" {
        align(center)[#college];
      } else {}
      grid(
        columns: (1fr, 3fr, 1fr),
        align(left, 
          if lhead != none {
            if lhead != "" {lhead} else {semester(date)}
        }),
        align(center, text(16pt)[
          #if chead != "" {chead} else if course != "" [#course --- #kind] else [#kind]
        ]),
        align(right, 
          if rhead != none {
            if rhead != "" {rhead} else {"Ver. " + version}
        })
      )
      line(length: 100%);
    },
    header-ascent: 10%,
    footer: {
      set text(10pt, weight: "bold")
      grid(
        columns:(1fr, 5em, 1fr),
        align: (left, center, right),
        if lfoot != none {
          if lfoot != "" { lfoot } else { datedisp(date) }
        },
        counter(page).display("1 / 1", both: true),
        if rfoot != none {
          if rfoot != "" {rfoot} else { instructor }
        }
      )
    }
  )
  
  // Update global state show solution
    
  show_sol.update(sol)
  
  // Set intro and name  
  
  // Intro
  if intro != none {
  block(
    fill: rgb("#98e3fd").lighten(70%), 
    inset: 0.5em, 
    width: 100%, 
    above: 0em,
    radius: 0.3em, 
    stroke: (2pt + red)
  )[
    #set text(12pt)
    #set par(
      leading: 0.8em,
      justify: true
    )
    #pad(x: 0.5em)[
      #intro \
    ]
  ]
  }
  
  // Name and grade box
  
  let cell(content) = {
    set align(left)
    rect(
      width: 100%,
      height: 100%,
      inset: 0.5em,
      stroke: 1.5pt, //(left: 1pt, right: 1pt),
      [
        #set text(14pt, weight: "medium")
        #content
      ]
    )
  }
  
  if namebox {
    grid(
      columns: (auto, 2in),
      rows: (0.6in),
      cell()[#smallcaps("Name (PRINT):")],
      cell()[
        #smallcaps("Grade:") 
        // #align(end)[#text(16pt)[#text(24pt)[/]#pointtotal #smallcaps[pts]]]
      ]
    )
  }
  
  // End before-body
  
  // Main body.

  // Text settings
  // set text(12pt)
  
  // Set paragraph spacing.
  // show par: set block(above: 1em, below: 1em)

  show heading.where(level: 2): it => {
    set block(above: 1.2em, below: 1em)
    set text(weight: 600)
    question[#it.body]
  }
  
  show heading.where(level: 3): it => {
    set text(weight: "regular")
    part(points: none)[#it.body]
  }


  let inline_list(counter-fmt, it) = {
    if it.tight {
      grid(
        columns: (1fr,) * calc.min(it.children.len(), 4),
        column-gutter: 0.5em,
        row-gutter: 1.2em,
        ..it.children
            .enumerate()
            .map(((n, item)) => grid(
              columns: (auto, 1fr),
              column-gutter: .5em,
              counter-fmt(n + 1),
              item.body,
            ))
      )
    } else {
      it
    }
  }

  // show list: inline-list.with(_ => sym.bullet)
  show enum: inline_list.with(numbering.with("1)"))

  // Content-Body
  body

  // Footer

    // v(1fr)
    // place(end, dx:3em, dy:1.5em)[
    //     #text(size: 14pt, weight: "bold")[#upper[End of Questions]]
    // ] 
 
  // v(1fr)
  // place(bottom + end)[
  //   #box(stroke: 1pt, inset: 0.8em)[
  //       #text(16pt, sym.sum) :  \_\_\_\_ \/ #total_points.display() #smallcaps("PT")
  //   ]
  // ]
}

