import React from "react"
import ReactDOM from "react-dom"
import $ from "jquery"

class Posts extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      posts: []
    }
  }

  componentDidMount() {
    this.props.channel.on("new-post", payload => {
      const posts = Array(payload).concat(this.state.posts)
      this.setState({ posts })
    })
    this.props.channel.join().receive("ok", resp => {
      console.log("listening for new posts")
    })
    $.get("/posts", response => {
      this.setState({posts: response.data})
    })
  }

  render() {
    const posts = this.state.posts.map(p => <Post key={p.reddit_id} {...p} onHide={this.onHide.bind(this, p)} />)
    return (
      <div className="posts">
        {posts}
      </div>
    )
  }

  onHide(post) {
    $.ajax({
      method: 'PUT',
      url: `/posts/${post.id}`,
      data: { post: {hidden: true} },
      dataType: 'json',
      success: data => {
        const posts = this.state.posts.filter(p => p !== post)
        this.setState({ posts })
      }
    })
  }
}

class Post extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      hidden: false
    }
  }

  render() {
    const classes = ''
    return (
      <div className="py-1r">
        <h5>
          <input type="checkbox" onClick={this.props.onHide} />
          {' '}<a href={this.props.url}>{this.props.title}</a>
        </h5>
        <p className={classes}>{this.props.text}</p>
      </div>
    )
  }
}

export default Posts
