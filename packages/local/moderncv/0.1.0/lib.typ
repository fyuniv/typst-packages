// const icons
#let icon_size = 1em

#let colored_icon(path: "", color: "", size: icon_size) = {
  box(
    baseline: 15%,
    height: size,
    if color == "" {
      image(path)
    } else {
      image.decode(
        read(path).replace(
          "#CC5500",
          color.to-hex(),
        )
      )
    }
  )
}

#let orchid_icon_path = "icons/orcid.svg"
#let phone_icon_path = "icons/phone-solid.svg"
#let email_icon_path = "icons/envelope-solid.svg"
#let web_icon_path = "icons/globe-solid.svg"
#let github_icon_path = "icons/github-mark.svg"
#let bookmark_icon_path = "icons/bookmark-solid.svg"

#let github_link = "https://github.com/"
#let orcid_link = "https://orcid.org/"

#let icon_link(icon, web, account_name) = {
  align(horizon)[
    #icon
    #link(web + account_name, account_name)
  ]
}

//Resume layout

#let left_column_width = 18%
#let column_gutter = 1em
#let parindent = 1.5em

//Resume color
#let state_primary_color = state(
  "primarycolor",
  rgb("#2e59a7")
)
#let state_accent_color = state(
  "accentcolor",
  rgb("#2e59a7")
)

#let state_headinglayout = state(
  "headinglayout",
  "grid"
)
#let state_liststyle = state(
  "liststyle",
  "plain"
)


#let resume(
  title: "",
  author: (
      firstname: "", 
      lastname: "",
      email: "", 
      address: [],
      positions: (
        "",
      ),
      phone: "",
      github: "",
      orcid: "",
      web: ""
  )+(:), 
  date: datetime.today().display("[month repr:long] [day], [year]"), 
  theme: (
    headinglayout: "",
    primarycolor: rgb("#2e59a7"),
    accentcolor: rgb("#2e59a7"),
    font: "Noto Sans",
    liststyle: "fancy"
    )+(:),
  body
) = {
  set text(
    font: theme.font,
    lang: "en",
    size: 11pt,
    fallback: true
  )

  // Set up theme color
  let primary_color = theme.primarycolor
  let accent_color = theme.accentcolor

  set document(
    author: author.firstname + " " + author.lastname, 
    title: title,
  )
  // Set page style 

  set page(
    paper: "us-letter",
    margin: (left: 0.6in, right: 0.6in, top: 0.6in, bottom: 0.6in),
    footer: 
      {set text(fill: accent_color, size: 8pt);
      grid(
        columns: (1fr,1fr,1fr),
        align: (left, center, right),
        smallcaps[#date],
        counter(page).display("1 / 1", both: true),
        smallcaps[
          #author.firstname
          #author.lastname
          #sym.dot.c
          #title
        ],
      )}
  )


  state_primary_color.update(primary_color)
  state_accent_color.update(accent_color)

  state_headinglayout.update(theme.headinglayout)
  state_liststyle.update(theme.liststyle)

  // Set paragraph spacing
  
  set block(above: 1em, below: 1.1em)
  set par(justify: true)

  // Set heading styles
  
  set heading(
    numbering: none,
    outlined: false,
  )

  show heading: set block(above: 1em)

  show heading.where(level:1): it =>  {
    set text(
      size: 1.2em,
      weight: "bold",
      fill: primary_color
    )
    if theme.headinglayout == "grid" {
      grid(
        columns: (left_column_width, 1fr),
        column-gutter: column_gutter,
        align(horizon, line(stroke: 5pt + gradient.linear(primary_color, primary_color.lighten(20%), angle: 0deg), length: 100%)),
        pad(left: -0.5em, it.body)
      )
    } else {
      box(
        width: 100%,
        stroke: (bottom: 3pt + gradient.linear(primary_color, white, angle: 0deg)),
        inset: (bottom: 0.5em),
        it.body
      )
    }
  }

  show heading.where(level: 2): it => {
    set text(
      size: 1.1em, 
      style: "normal", 
      fill: primary_color, 
      weight: "semibold"
    )
    if theme.headinglayout == "grid" {
      grid(
        columns: (left_column_width, 1fr),
        align: (right, left),
        column-gutter: column_gutter,
        [],
        pad(left: -0.25em, it.body)
      )
    } else {
      it.body
    }
  }

  set enum(
    numbering: n => {
      box(
        baseline: if theme.liststyle == "fancy" {-40%} else {12.5%}, 
        width: if theme.headinglayout == "grid" {left_column_width} else {parindent}
      )[
        #if theme.liststyle == "fancy" {
          place(
            dy: -0.1em,
            dx: if theme.headinglayout == "grid" {(column_gutter/2)} else {0em}, 
              rect(
                radius: 0.3em,
                width: 1em,
                height: 1em, 
                fill: primary_color.lighten(30%), 
                align(
                  center+horizon,
                  text(fill: white, weight: "bold", size: 0.8em)[#n]
                )
              )
          )
        } else {
          [#n.]
        }
      ]
    },
    indent: if theme.headinglayout == "grid" {0em} else {parindent},
    body-indent: if theme.headinglayout == "grid" {column_gutter+0.25em} else {column_gutter/2},
    spacing: 1.2em,
    tight: false
  )


  // Set name style
  
  let name =  {
      set text(
        size: 2.5em, 
        weight: "bold", 
        fill: primary_color
      )
    pad(bottom: 0em)[
      #author.firstname
      #h(0.2em)
      #author.lastname
    ]
  }

  // Set position style
  
  let positions =  {
    set text(
      accent_color,
      size: 0.8em,
      weight: "regular"
    )
    smallcaps(
      author.positions.join(
        text[\ ]
      )
    )
  }

  // Set address style
  let address = {
    set text(
      size: 0.8em,
      weight: "bold",
      style: "italic",
    )
    align(right, author.address)
  }

  // Set contact information styles
  
  let contactinfo = {
    align(right)[
      #set text(size: 0.8em, weight: "regular", style: "normal")
      #align(horizon)[
        #if (author.phone != "") {
          {colored_icon(path: phone_icon_path, color: accent_color)}
          box(inset: (left: 6pt),  
            author.phone
          )
        }
        
        #if (author.email != "") {
          {colored_icon(path: email_icon_path, color: accent_color)}
          box(inset: (left: 6pt), link("mailto:" + author.email)[#author.email])
        }
      ]
    ]
  }
  
  let socialinfo = {
    set text(size: 0.9em, weight: "regular", style: "normal")
    grid(
      columns: (1fr, auto, auto, auto),
      column-gutter: 1.5em,
      align: (left, right, right, right),
      [],
      if (author.web != "") {
        icon_link({colored_icon(path: web_icon_path, color: accent_color)}, "", author.web)
      },
      if (author.orcid != "") {
        icon_link(colored_icon(path: orchid_icon_path, color: ""), orcid_link, author.orcid)
      },
      if (author.github != "") {
        icon_link({colored_icon(path: github_icon_path, color: accent_color)}, github_link, author.github)
      }
    )
  }
  
  grid(
    columns: (1fr, 2fr),
    align: (left, right), 
    {name; positions},
    {address; contactinfo},
  )
  socialinfo
  body
}

// Resume-list: marker will be placed on the left

#let resume_list(body) = {
  set text(size: 1em, weight: 400)

  show terms.item: it => {
    grid(
      columns: (left_column_width, 1fr),
      align: (right, left),
      column-gutter: column_gutter,
      it.term,
      it.description
    )
  }

  show list.item: it => context{
    grid(
      columns: (left_column_width, 1fr),
      align: (right, left),
      column-gutter: column_gutter,
      // context{
        if state_liststyle.get() == "fancy" {
          box(
            baseline: -12.5%,
            inset: (right: 0.25em), 
            width: left_column_width,
            // context{
              colored_icon(
                path: bookmark_icon_path, 
                color: state_primary_color.get().lighten(30%), 
                size: 0.75em
              )
            // }
          )
        } else [$bullet$]
      // }
      ,
      it.body
    )
  }

  body
}

#let resume_entry(
  date: "",
  title: "",
  department: "",
  university: "",
  location: "", 
  description: ""
) = {
  grid(
      columns: (left_column_width, auto, 1fr),
      align: (right, left, right),
      column-gutter: column_gutter,
      row-gutter: 0.65em,
      grid.cell(
        rowspan: 2,
        date,
      ),
      strong(title),
      department,
      emph(university),
      location,
      [],
      if description != "" {
        description
      }
    )
}

// Reverse the numbering of enum items. It was shared by frozolotl. A reimplement of enum can be found in https://gist.github.com/frozolotl/1eeafa5ff4a38b2aab412743bd9c1ded. It may be used to realize the same feature.

#let reverse(enumlist) =   context {
  let len = enumlist.children.filter(child => child.func() == enum.item).len()
  
  set enum(
    indent: if state_headinglayout.get() == "grid" {0em} else {parindent},
    body-indent:  if state_headinglayout.get() == "grid" { column_gutter + 0.25em } else { column_gutter/2 },
    numbering: n => context {
      box(
        baseline: if state_liststyle.get() == "fancy" {-40%} else {0%}, 
        width: if state_headinglayout.get() == "grid" {left_column_width} else {parindent}
      )[
        #if state_liststyle.get() == "fancy" {
          place(
            dy: -0.1em,
            dx: if state_headinglayout.get() == "grid" {(column_gutter/2)} else {0em}, 
              rect(
                radius: 0.3em,
                width: 1em,
                height: 1em, 
                fill: state_primary_color.get().lighten(30%), 
                align(
                  center+horizon,
                  text(fill: white, weight: "bold", size: 0.8em)[#(1 + len - n)]
                )
              )
          )
        } else {
          [#(1 + len - n).]
        }
      ]
    }, 
    spacing: 1.2em,
    tight: false
  )

  enumlist
}

// ---- End of Resume Template ----
