@react.component
let make = (~children, ~href) => {
  <a href className="font-medium text-blue-600 dark:text-blue-500 hover:underline"> {children} </a>
}
